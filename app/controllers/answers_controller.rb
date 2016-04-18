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

  include Voted

  def create
    @question = Question.find(params[:question_id])
    @answer = current_user.answers.build(answer_params.merge(question: @question))
    @answer.save
  end

  def update
    @question = @answer.question
    @answer.update(answer_params) if current_user.is_author?(@answer)
  end

  def destroy
    @answer.destroy if current_user.is_author?(@answer)
    render nothing: true
  end

  def best
    @question = @answer.question
    @answer.choose_as_best if current_user.is_author?(@question)
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:content, attachments_attributes: [:id, :file, :_destroy])
  end
end
