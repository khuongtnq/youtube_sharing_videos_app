require "test_helper"

class ApplicationCable::ConnectionTest < ActionCable::Connection::TestCase
  test 'connects with token' do
    user = User.first
    token = user.generate_jwt
    connect params: {}, headers: { 'Authorization' => "Bearer #{token}" }
    assert_equal connection.current_user.id, user.id
  end

  test 'reject connection' do
    assert_reject_connection { connect params: {}, headers: {} }
  end
end
