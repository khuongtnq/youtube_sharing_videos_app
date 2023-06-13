require "rails_helper"

RSpec.describe ApplicationCable::Connection, type: :channel do
  describe '#connect' do
    let(:user) { create(:user) }
    let(:headers) { { 'Authorization' => "Bearer #{user.generate_jwt}" } }

    it 'connects with token' do
      expect(connection.current_user.id).to eq(user.id)
    end
  end

  describe '#reject_connection' do
    it 'rejects connection' do
      expect { connect headers: {} }.to have_rejected_connection
    end
  end
end