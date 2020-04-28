class TweetPolicy < ApplicationPolicy
  
  def update?
    valid_user?
  end

  def destroy?
    valid_user?
  end

  private
  def valid_user?
    user.admin? or record.user_id == user.id
  end
end