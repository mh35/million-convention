require 'json'
require 'net/http'
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
    api_http = Net::HTTP.new('api.line.me', 443)
    api_http.use_ssl = true
    token_resp = nil
    api_http.start do
      token_resp = api_http.post_form('/oauth2/v2.1/token', {
        'grant_type' => 'authorization_code',
        'code' => params['code'],
        'redirect_uri' =>
          'https://million-convention.mh35.info/login/callback',
        'client_id' => ENV['LINE_OPENID_CHANNEL_ID'],
        'client_secret' => ENV['LINE_OPENID_CHANNEL_SECRET']
      })
    end
    unless token_resp.code.to_i < 300
      flash[:error_msg] = 'ログイン処理でエラーが発生しました'
      redirect_to controller: 'top', action: 'index'
      return
    end
    token_body = JSON.parse(token_resp.body)
    access_token = token_body['access_token']
    expire_time = Time.now + token_body['expires_in']
    refresh_token = token_body['refresh_token']
    id_token = token_body['id_token']
    decoded_token = JWT.decode(id_token, ENV[
      'LINE_OPENID_CHANNEL_SECRET'], true, {algorithm: 'HS256'})
    decoded_id_token = decoded_token[0]
    unless decoded_id_token['iss'] == 'https://access.line.me' &&
      decoded_id_token['aud'] == ENV['LINE_OPENID_CHANNEL_ID'] &&
      decoded_id_token['nonce'] == session[:login_nonce]
      flash[:error_msg] = '不正なIDトークンです'
      redirect_to controller: 'top', action: 'index'
      return
    end
    flash[:error_msg] = decoded_id_token['name']
    redirect_to controller: 'top', action: 'index'
  end
end
