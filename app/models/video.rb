# == Schema Information
#
# Table name: videos
#
#  id            :bigint           not null, primary key
#  description   :text
#  thumbnail_url :string
#  title         :string
#  url           :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  sharer_id     :integer          not null
#
class Video < ApplicationRecord
  belongs_to :sharer, class_name: "User", foreign_key: "sharer_id"
  validates :title, :url, presence: true
end
