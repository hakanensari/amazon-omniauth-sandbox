require "sinatra"
require "omniauth/amazon"

configure :production do
  require "rack/ssl-enforcer"
  use Rack::SslEnforcer
end

use Rack::Session::Cookie, secret: ENV['SECRET']
use OmniAuth::Builder do
  provider :amazon, ENV["AMAZON_CLIENT_ID"], ENV["AMAZON_CLIENT_SECRET"], scope: "profile postal_code"
end

get "/" do
  <<-HTML
  <a href="/auth/amazon">
    <img src="https://images-na.ssl-images-amazon.com/images/G/01/lwa/btnLWA_drkgry_156x32.png">
  </a>
  HTML
end

get '/auth/amazon/callback' do
  auth = request.env['omniauth.auth']
  <<-HTML
  <ul>
    <li>uid: #{auth.uid}</li>
    <li>email: #{auth.info.email}</li>
    <li>name: #{auth.info.name}</li>
    <li>postal_code: #{auth.extra.postal_code}</li>
  </ul>
  HTML
end
