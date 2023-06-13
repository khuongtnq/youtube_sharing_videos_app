require 'rails_helper'

RSpec.describe V1::VideoApi, type: :request do
  let(:user) { create(:user) }
  let(:headers) { { 'Authorization' => "Bearer #{user.generate_jwt}" } }

  describe 'GET /api/v1/videos' do
    let!(:videos) { create_list(:video, 3, sharer: user) }

    before do
      get '/api/v1/videos', headers: headers, params: { page: 1, per: 2 }
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns the correct number of videos' do
      expect(JSON.parse(response.body)['meta']['total_count']).to eq(3)
    end

    it 'returns the correct video attributes' do
      expect(JSON.parse(response.body)['videos'][0]['url']).to eq(videos[0].url)
    end
  end

  describe 'POST /api/v1/videos' do
    context 'with valid params' do
      let(:valid_params) { { url: 'https://www.youtube.com/watch?v=123456789' } }

      before do
        allow(VideoInfo).to receive(:new).and_return(double(title: 'Test title', description: 'Test description', thumbnail_medium: 'test_thumbnail'))
        post '/api/v1/videos', headers: headers, params: valid_params
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'creates a new video for the user' do
        expect(user.videos.count).to eq(1)
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { { url: nil } }

      before do
        post '/api/v1/videos', headers: headers, params: invalid_params
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns an error message' do
        expect(JSON.parse(response.body)['error']).to eq("cannot save videos")
      end
    end
  end
end