# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, except: [:index, :new, :create]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question was successfully created.'
    else
      flash.now[:error] = 'Your question was not created!'
      render :new
    end
  end

  def update
    if current_user.is_author?(@question) && @question.update(question_params)
      flash.now[:notice] = 'Your question was successfully updated.'
    else
      flash.now[:error] = 'Your question was not updated!'
    end
  end

  def destroy
    if current_user.is_author?(@question)
      @question.destroy
      flash[:notice] = 'Your question was successfully deleted.'
    end

    redirect_to root_url
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :content, attachments_attributes: [:id, :file, :_destroy])
  end
end
