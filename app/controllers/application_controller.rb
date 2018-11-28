class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :prepare_default_title

  private

  def prepare_default_title
    @title = 'コンベンションセンター'
  end

  def require_admin
    unless session[:is_admin]
      redirect_to controller: 'top', action: 'index'
    end
  end

  def require_login
    unless session[:uid]
      redirect_to controller: 'top', action: 'index'
    end
  end
end
