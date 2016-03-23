class AnswersController < ApplicationController
  before_action :authenticate_user!, :set_question

  def create
    @answer = current_user.answers.build(answer_params.merge(question_id: @question.id))

    if @answer.save
      redirect_to @question, notice: 'Your answer was successfully created.'
    else
      flash.now[:error] = 'Your answer was not created!'
      render 'questions/show'
    end
  end

  def destroy
    answer = Answer.find(params[:id])

    if current_user.is_author?(answer)
      answer.destroy
      flash[:notice] = 'Your answer was successfully deleted.'
    end

    redirect_to @question
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:content)
  end
end
