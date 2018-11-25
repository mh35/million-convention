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
      session[:login_state] = nil
      session[:login_nonce] = nil
      flash[:error_msg] = 'リクエストは拒否されました'
      redirect_to controller: 'top', action: 'index'
      return
    end
    unless params[:state] == session[:login_state]
      session[:login_state] = nil
      session[:login_nonce] = nil
      flash[:error_msg] = '不正なログインです'
      redirect_to controller: 'top', action: 'index'
      return
    end
    # After this, get request token
    post_url = URI.parse('https://api.line.me/oauth2/v2.1/token')
    token_resp = Net::HTTP.post_form(post_url, {
      'grant_type' => 'authorization_code',
      'code' => params['code'],
      'redirect_uri' =>
        'https://million-convention.mh35.info/login/callback',
      'client_id' => ENV['LINE_OPENID_CHANNEL_ID'],
      'client_secret' => ENV['LINE_OPENID_CHANNEL_SECRET']
    })
    unless token_resp.code.to_i < 300
      session[:login_state] = nil
      session[:login_nonce] = nil
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
      session[:login_state] = nil
      session[:login_nonce] = nil
      flash[:error_msg] = '不正なIDトークンです'
      redirect_to controller: 'top', action: 'index'
      return
    end
    line_uid = decoded_id_token['sub']
    user = User.where(line_uid: line_uid).first
    unless user
      user = User.new
      user.last_wrote_at = Time.now - 3600
      user.last_thread_created_at = Time.now - 3600
    end
    user.line_uid = line_uid
    user.access_token = access_token
    user.refresh_token = refresh_token
    user.access_token_expires_at = expire_time
    user.display_name = decoded_id_token['name']
    user.save
    session[:uid] = user.id
    session[:display_name] = decoded_id_token['name']
    session[:login_state] = nil
    session[:login_nonce] = nil
    session[:is_admin] = (line_uid == ENV['LINE_ADMIN_UID'])
    flash[:notice_msg] = 'ログインしました'
    redirect_to controller: 'top', action: 'index'
  end

  def logout
    session[:uid] = nil
    session[:display_name] = nil
    session[:is_admin] = nil
    flash[:notice_msg] = 'ログアウトしました'
    redirect_to controller: 'top', action: 'index'
  end
end
