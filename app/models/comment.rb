class Comment < ApplicationRecord
  include PublicActivity::Common

  belongs_to :event
  belongs_to :user

  validates :content, length: {in: 3..150,
                               too_short: 'Must be at least 3 characters',
                               too_long: 'Must be less than 150 characters'},
                      presence: true
end
