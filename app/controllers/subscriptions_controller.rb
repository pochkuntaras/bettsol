# == Schema Information
#
# Table name: subscriptions
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  question_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :build_subscription, only: :create

  load_and_authorize_resource

  respond_to :js

  def create
    @subscription.save
    respond_with @subscription
  end

  def destroy
    respond_with @subscription.destroy
  end

  private

  def build_subscription
    question = Question.find(params[:question_id])
    @subscription = current_user.subscriptions.build(question: question)
  end
end
