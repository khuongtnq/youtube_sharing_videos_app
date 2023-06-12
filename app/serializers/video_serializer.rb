class VideoSerializer < ActiveModel::Serializer
  attributes :id, :description, :thumbnail_url, :title, :url, :sharer_id, :created_at
end
