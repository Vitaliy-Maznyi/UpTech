class Event < ApplicationRecord
  include PublicActivity::Common
  mount_base64_uploader :image, ImageUploader

  belongs_to :user
  has_many :participants, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :name, :time, :place, :purpose, presence: true
  validates :name, length: { maximum: 30, message: 'Must be less than 30 characters'}
  validates :place, length: { maximum: 40, message: 'Must be less than 40 characters'}
  validates :purpose, length: { maximum: 150, message: 'Must be less than 150 characters'}
  validates :name, :place, :purpose, length: {minimum: 3, message: 'Must be at least 3 characters'}
end
