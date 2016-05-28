module ApplicationHelper
  def vote_for(votable)
    render partial: 'layouts/vote', locals: { votable: votable }
  end

  def select_search_scope
    select_tag :scope, options_for_select(ThinkingSphinx::SCOPE.map { |s| [t('.' + s), s] }), prompt: 'All'
  end

  def render_search_resource(resource)
    case resource
      when Question
        link_to %Q(Question "#{resource.title}"), resource
      when Answer
        link_to %Q(Answer for "#{resource.question.title}"), resource.question
      when Comment
        case resource.commentable
          when Question
            link_to %Q(Comment for question "#{resource.commentable.title}"), resource.commentable
          when Answer
            link_to %Q(Comment for answer to question "#{resource.commentable.question.title}"), resource.commentable.question
          else
            "Comment for #{resource.class.to_s.downcase}"
        end
      when User
        "User: #{resource.email}"
      else
        resource.class.to_s.downcase
    end
  end
end
