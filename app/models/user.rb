class User < ApplicationRecord
  rolify
  devise :database_authenticatable, :registerable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JWTBlacklist

  validates :email, presence: true
  has_many :tweets


  def admin?
    has_role?(:admin)
  end

  def generate_password_token!
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.zone.now.utc
    save!
  end

  def password_token_valid?
    (self.reset_password_sent_at + 4.hours) > Time.now.utc
  end

  def reset_password!(password)
    self.reset_password_token = nil
    self.password = password
    save!
  end

  private

  def generate_token
   SecureRandom.hex(10)
  end

end
