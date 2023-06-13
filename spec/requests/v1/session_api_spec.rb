require 'rails_helper'

RSpec.describe V1::SessionApi, type: :request do
  include Rack::Test::Methods
  describe 'POST /api/v1/login' do
    let!(:user) { create(:user, password: 'youtube@123') }
    let(:valid_params) do
      {
        email: user.email,
        password: 'youtube@123'
      }
    end

    context 'when request is valid' do
      before { post '/api/v1/login', params: valid_params }

      it 'returns success status' do
        expect(response.status).to eq(201)
      end

      it 'returns access_token and user information' do
        response_body = JSON.parse(response.body)
        expect(response_body['access_token']).not_to be_nil
        expect(response_body['user']).not_to be_nil
      end
    end

    context 'when request is invalid' do
      it 'returns error status and message for wrong email' do
        invalid_params = valid_params.merge(email: 'wrong_email@example.com')
        post '/api/v1/login', params: invalid_params

        expect(response.status).to eq(401)
        expect(JSON.parse(response.body)['error']).to eq("Invalid email, password or password.")
      end

      it 'returns error status and message for wrong password' do
        invalid_params = valid_params.merge(password: 'wrong_password')
        post '/api/v1/login', params: invalid_params

        expect(response.status).to eq(401)
        expect(JSON.parse(response.body)['error']).to eq("Invalid email, password or password.")
      end
    end
  end

  describe 'POST /api/v1/sign_up' do
    let(:user) { create(:user) }
    let(:params) do
      {
        email: 'test@example.com',
        password: 'password',
        password_confirmation: 'password'
      }
    end

    subject { post '/api/v1/sign_up', params }

    context 'with valid params' do
      it 'creates a new user' do
        expect { subject.body }.to change(User, :count).by(1)
        expect(subject.status).to eq(201)
      end
    end

    context 'with invalid params' do
      let(:params) { { email: '', password: '', password_confirmation: '' } }

      it 'returns error message' do
        subject
        expect(subject.status).to eq(422)
      end
    end
  end

  describe 'DELETE /api/v1/logout' do
    let(:user) { create(:user) }
    let(:params) do
      {
        email: 'test@example.com',
        password: 'password',
        password_confirmation: 'password'
      }
    end
    subject { delete '/api/v1/logout', {}, 'Authorization' => "Bearer #{user.generate_jwt}" }

    context 'with a valid token' do
      it 'logs out the user' do
        subject
        expect(subject.status).to eq(401)
        expect(JSON.parse(subject.body)['error']).to be_truthy
      end
    end

    context 'with an invalid token' do
      let(:invalid_token) { 'invalid_token' }
      subject { delete '/api/v1/logout', {}, 'Authorization' => "Bearer #{invalid_token}" }

      it 'returns error message' do
        subject
        expect(subject.status).to eq(401)
        expect(JSON.parse(subject.body)['error']).to eq('Unauthorized')
      end
    end
  end
end