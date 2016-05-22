# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  question_id :integer          not null
#  content     :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#  best        :boolean          default(FALSE), not null
#

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :build_answer, only: :create

  after_action :publish_answer, only: :create

  load_and_authorize_resource

  include Voted

  respond_to :json, only: [:create, :destroy]
  respond_to :js, only: :update

  def create
    respond_with @answer
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def destroy
    respond_with(@answer.destroy, location: question_path(@answer.question))
  end

  def best
    @answer.choose_as_best
  end

  private

  def build_answer
    @question = Question.find(params[:question_id])
    @answer = current_user.answers.create(answer_params.merge(question: @question))
  end

  def publish_answer
    if @answer.valid?
      PrivatePub.publish_to "/questions/#{@question.id}/answers", JSON.parse_nil(render_to_string 'show.json')
    end
  end

  def answer_params
    params.require(:answer).permit(:content, attachments_attributes: [:id, :file, :_destroy])
  end
end
