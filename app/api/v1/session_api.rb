module V1
  class SessionApi < Grape::API
    desc 'POST api/v1/login'
    params do
      requires :email, type: String
      requires :password, type: String
    end
    post :login do
      begin
        user = User.where(email: params[:email]).first
        if user && user.valid_password?(params[:password])
          token = user.generate_jwt

          { access_token: token, user: user.info }
        else
          error!(I18n.t('devise.failure.invalid', authentication_keys: 'email, password'), 401)
        end
      rescue StandardError => e
        error!(e.message, 401)
      end
    end

    desc 'POST api/v1/sign_up'
    params do
      requires :email, type: String
      requires :password, type: String
      requires :password_confirmation, type: String
    end
    post :sign_up do
      begin
        user = User.create(params)
        raise ActiveRecord::RecordInvalid, user if user.errors.any?

        { user: user.info }
      rescue StandardError => e
        error!(e.message, 422)
      end
    end

    desc 'DELETE api/v1/logout'
    delete :logout do
      authenticate!
      begin
        AuthenticationToken.authenticate(@token).destroy
        result = { status: true }
        { processed: true }
      rescue StandardError => e
        error!(e.message, 500)
      end
    end
  end
end
