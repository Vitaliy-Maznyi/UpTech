class EventShowSerializer < ActiveModel::Serializer
  attributes :id, :name, :time, :place, :purpose, :user_id
  has_many :participants
  has_many :comments
end

