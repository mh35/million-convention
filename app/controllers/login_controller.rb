require 'uri'

class LoginController < ApplicationController
  def index
    if ENV['RAILS_ENV'] == 'production'
      # LINE authorization
      login_chrs = ('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a
      session[:login_state] = (0...12).map{|z| login_chrs[
        rand(login_chrs.length)]}.join('')
      session[:login_nonce] = (0...12).map{|z| login_chrs[
        rand(login_chrs.length)]}.join('')
      auth_url = 'https://access.line.me/oauth2/v2.1/authorize?' +
        'response_type=code&client_id=' + URI.escape(
        ENV['LINE_OPENID_CHANNEL_ID']) + '&redirect_uri=' +
        URI.escape('https://million-convention.mh35.info/login/callback') +
        '&state=' + session[:login_state] + '&scope=profile%20openid&' +
        'nonce=' + session[:login_nonce] + '&max_age=600'
      redirect_to auth_url
    else
      # Check authorization stop
      redirect_to :back
    end
  end
  
  def callback
    if params[:error]
      flash[:error_msg] = 'リクエストは拒否されました'
      redirect_to controller: 'top', action: 'index'
      return
    end
    unless params[:state] == session[:login_state]
      flash[:error_msg] = '不正なログインです'
      redirect_to controller: 'top', action: 'index'
      return
    end
    # After this, get request token
  end
end
