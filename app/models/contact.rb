class Contact < ApplicationRecord
  with_options presence: true do
    validates :name,         length: { maximum: 30 }
    validates :email,        length: { maximum: 255 },
                             format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
    validates :types,
    validates :content,      length: { maximum: 255 },
  end
end

