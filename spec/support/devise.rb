RSpec.configure do |config|
  # Request specでDeviseのログインメソッドを使えるようにする
  config.include Devise::Test::IntegrationHelpers, type: :request
end