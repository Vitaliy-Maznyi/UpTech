class ActivitySerializer < ActiveModel::Serializer
  attributes :id, :trackable_type, :owner_id, :key, :recipient_id, :created_at
end
