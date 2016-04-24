# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  commentable_id   :integer          not null
#  commentable_type :string           not null
#  content          :text             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class CommentsController < ApplicationController
  before_action :authenticate_user!, :set_commentable

  def create
    @comment = current_user.comments.build(comment_params.merge(commentable: @commentable))

    if @comment.save
      PrivatePub.publish_to '/comments', JSON.parse_nil(render_to_string 'show.json')
      render json: { notice: 'Your answer was comment created.' }
    else
      render json: { errors: @comment.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_commentable
    commentable_id = params.keys.detect { |k| k =~ /(question|answer)_id/ }
    @commentable = $1.classify.constantize.find(params[commentable_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
