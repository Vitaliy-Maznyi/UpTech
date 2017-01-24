class EventIndexSerializer < ActiveModel::Serializer
  attributes :id, :name, :time, :place
end