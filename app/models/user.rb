class User < ApplicationRecord
  devise :database_authenticatable, :registerable

  has_many :events, dependent: :destroy
  has_many :participants, dependent: :destroy
  has_many :comments

  validates_uniqueness_of :username
end
