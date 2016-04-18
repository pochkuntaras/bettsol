module ApplicationHelper
  def vote_for(votable)
    render partial: 'layouts/vote', locals: { votable: votable }
  end
end
