class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question

  load_and_authorize_resource

  skip_load_resource only: :create

  def index
    respond_with @question.answers
  end

  def show
    respond_with @answer
  end

  def create
    respond_with current_resource_owner.answers.create(answer_params.merge(question: @question))
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:content)
  end
end
