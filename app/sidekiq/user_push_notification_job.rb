class UserPushNotificationJob
  include Sidekiq::Job

  def perform(params = {})
    params = JSON.parse(params).symbolize_keys
    return unless params[:title] && params[:body]

    params[:username] ||= 'System'
    notification = Notification.new(title: params[:title], body: params[:body], user_id: params[:user_id])
    if notification.save
      ActionCable.server.broadcast('notification_global', { title: notification.title, body: notification.body, from: params[:username] })
    else
      p notification.errors.full_messages.join(', ')
    end
  end
end
