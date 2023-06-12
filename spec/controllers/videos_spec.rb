require 'rails_helper'

RSpec.describe Video, type: :controller do
  describe "get all questions route", :type => :request do
    let!(:videos) {FactoryBot.create_list(:video, 10)}

    before {get '/api/v1/videos'}

    it 'returns all questions' do
      expect(JSON.parse(response.body).size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end
  end
end