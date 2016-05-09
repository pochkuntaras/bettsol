class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :like, :dislike, :indifferent, to: :vote

    if user
      can :create, [Comment, Question, Answer]
      can [:update, :destroy], [Question, Answer], user_id: user.id

      can :vote, [Question, Answer] do |object|
        object.user_id != user.id
      end

      cannot [:like, :dislike], [Question, Answer] do |object|
        user.voted_for?(object)
      end

      can :indifferent, [Question, Answer] do |object|
        user.voted_for?(object)
      end

      can :best, Answer do |object|
        object.question.user_id == user.id && ! object.best?
      end

      can [:index, :me], :profile
    end

    can :read, :all
  end
end
