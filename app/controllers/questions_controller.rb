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
  before_action :build_question, only: :create

  after_action :publish_question, only: :create

  load_and_authorize_resource

  include Voted

  before_action :set_subscription, only: [:show, :update]

  respond_to :js, only: :update

  def index
    respond_with @questions
  end

  def show
    gon.question_id = @question.id
    respond_with @question
  end

  def new
    respond_with @question
  end

  def create
    @question.save
    respond_with @question
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy, location: root_url)
  end

  private

  def build_question
    @question = current_user.questions.build(question_params)
  end

  def set_subscription
    @subscription = current_user.subscriptions.find_by(question: @question) if current_user
  end

  def publish_question
    PrivatePub.publish_to '/questions', JSON.parse_nil(render_to_string 'show.json') if @question.valid?
  end

  def question_params
    params.require(:question).permit(:title, :content, attachments_attributes: [:id, :file, :_destroy])
  end
end
