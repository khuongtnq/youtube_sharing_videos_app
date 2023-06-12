require 'rails_helper'

RSpec.describe Videos, type: :controller do
  describe "GET #show" do
    before do
      get :show, id: article.id
    end

    let(:article) { Article.create(title: 'Hello World') }

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "response with JSON body containing expected Article attributes" do
      hash_body = nil
      expect { hash_body = JSON.parse(response.body).with_indifferent_access }.not_to raise_exception
      expect(hash_body.keys).to match_array([:id, :title])
      expect(hash_body).to match({
                                   id: article.id,
                                   title: 'Hello World'
                                 })
    end
  end
end