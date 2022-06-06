class Contact < ApplicationRecord
    validates :name, :email, :types, :content, presence: true
end
