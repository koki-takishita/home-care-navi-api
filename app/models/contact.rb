class Contact < ApplicationRecord
    validates :name, :email, :types, :content, presence: true
    validates :name,  length: { maximum: 30 }
    validates :email,  length: { maximum: 255 },
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
end

