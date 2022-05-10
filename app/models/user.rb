class User < ApplicationRecord
  enum user_type: { costomer: 0, specialist: 1 }
            # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable
  include DeviseTokenAuth::Concerns::User
end
