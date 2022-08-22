include ActionController::RespondWith

module LoginSupport

	def login(user, user_type)
    post api_login_path,
    params: { email: user.email, password: 'password', user_type: user_type}
    .to_json,
    headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
  	return get_auth_params_from_login_response_headers(response)
	end

  def get_auth_params_from_login_response_headers(response)
    client = response.headers['client']
    token = response.headers['access-token']
    expiry = response.headers['expiry']
    token_type = response.headers['token-type']
    uid = response.headers['uid']

    auth_params = {
      'access-token' => token,
      'client' => client,
      'uid' => uid,
      'expiry' => expiry,
      'token-type' => token_type
    }
    auth_params
  end
end

RSpec.configure do |config|
  config.include LoginSupport
end
