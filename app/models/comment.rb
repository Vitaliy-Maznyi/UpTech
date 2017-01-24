class Comment < ApplicationRecord
  include PublicActivity::Common

  belongs_to :event
  belongs_to :user
end
