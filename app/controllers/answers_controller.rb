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
  before_action :set_answer, except: :create
  before_action :get_question_from_answer, only: [:update, :best]
  before_action :authorize_answer, only: [:update, :destroy]

  after_action :publish_answer, only: :create

  respond_to :json, only: [:create, :destroy]
  respond_to :js, only: :update

  include Voted

  def create
    @question = Question.find(params[:question_id])
    respond_with(@answer = current_user.answers.create(answer_params.merge(question: @question)))
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def destroy
    respond_with(@answer.destroy, location: question_path(@answer.question))
  end

  def best
    @answer.choose_as_best if current_user.is_author?(@question)
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def authorize_answer
    head :forbidden unless current_user.is_author?(@answer)
  end

  def get_question_from_answer
    @question = @answer.question
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
