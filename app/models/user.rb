# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_many :authentication_tokens, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :videos, class_name: "Video", foreign_key: :sharer_id, dependent: :destroy

  def generate_jwt
    payload = {
      id: id,
      email: email,
      exp: 1.day.from_now.to_i
    }.merge info
    access_token = JWT.encode(payload, Rails.application.secrets.secret_key_base)
    authentication_token = self.authentication_tokens.create
    authentication_token.digest!(access_token)
    access_token
  end

  def info
    {
      id: id,
      email: email
    }
  end
end
