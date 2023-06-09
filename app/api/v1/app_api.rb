module V1
  class AppApi < Grape::API
    version 'v1', using: :path
    format :json
    formatter :json, Grape::Formatter::ActiveModelSerializers

    rescue_from ActiveRecord::InvalidForeignKey do |e|
      error!(e.message, 422)
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      error!(e.message, 404)
    end

    namespace do
      namespace do
        mount V1::SessionApi
        mount V1::VideoApi
      end
    end

    helpers do
      def token
        @token ||= request.headers['Authorization'].scan(/Bearer (.*)$/).flatten.last.to_s
        return nil if @token.blank? || @token.split('.').count < 2
        return nil if AuthenticationToken.authenticate(@token).blank?
        @token
      end

      def data
        JWT.decode(token, Rails.application.secrets.secret_key_base)
      rescue => e
        nil
      end

      def current_user
        return @current_user if @current_user
        return nil unless data
        @current_user = User.find_by_email(data.first['email'])
      end

      def authenticate!
        error!(I18n.t('devise.failure.unauthenticated'), 401) unless current_user
      end

      def pagination_dict(collection)
        {
          current_page: collection.current_page,
          next_page: collection.next_page,
          prev_page: collection.prev_page,
          total_pages: collection.total_pages,
          total_count: collection.total_count
        }
      end
    end
  end
end
