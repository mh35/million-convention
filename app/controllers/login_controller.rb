require 'uri'

class LoginController < ApplicationController
  def index
    if ENV['RAILS_ENV'] == 'production'
      # LINE authorization
      auth_url = 'https://access.line.me/oauth2/v2.1/authorize?' +
        'response_type=code&client_id=' + URI.escape(
        ENV['LINE_OPENID_CHANNEL_ID']) + '&redirect_uri=' +
        URI.escape('https://million-convention.mh35.info/login/callback') +
        '&state='
    else
      # Check authorization stop
      redirect_to :back
    end
  end
  
  def callback
  end
end
