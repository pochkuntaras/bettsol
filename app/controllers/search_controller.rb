class SearchController < ApplicationController
  authorize_resource class: false

  def index
    @resources = klass_model.search(Riddle::Query.escape(params[:query].to_s), page: params[:page])
    respond_with @resources
  end

  private

  def klass_model
    ThinkingSphinx::SCOPE.include?(params[:scope]) ? params[:scope].classify.constantize : ThinkingSphinx
  end
end
