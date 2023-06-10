module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      User.find_by(id: user_id) || reject_unauthorized_connection
    end

    def received_token
      token = request.headers['Authorization']&.scan(/Bearer (.*)$/)&.flatten&.last
      return nil if token.blank? || token.split('.').count < 2
      return nil if AuthenticationToken.authenticate(token).blank?

      token
    end

    def user_id
      return unless received_token

      JWT.decode(received_token, Rails.application.secrets.secret_key_base).first['id']
    end
  end
end
