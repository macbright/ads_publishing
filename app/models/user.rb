class User < ApplicationRecord
  # has_secure_password
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JWTBlacklist
  
  

  validates_length_of       :password, maximum: 72, minimum: 8, allow_nil: true, allow_blank: false
  validates_confirmation_of :password, allow_nil: true, allow_blank: false

  before_validation { 
    (self.email = self.email.to_s.downcase)
  }

  # Make sure email and username are present and unique.
  validates_presence_of     :email
  validates_uniqueness_of   :email


  # acts_as_token_authenticatable

  def can_modify_user?(user_id)
    role == 'admin' || id.to_s == user_id.to_s
  end

  def change_to_admin(user)
    user.role = 'admin'
    user.save
  end
  # This method tells us if the user is an admin or not.
  def is_admin?
    role == 'admin'
  end
end
