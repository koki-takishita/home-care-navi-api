class Thank < ApplicationRecord
  belongs_to :user
  belongs_to :office
  belongs_to :staff
end
