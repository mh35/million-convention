class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :prepare_default_title

  private

  def prepare_default_title
    @title = 'コンベンションセンター'
  end
end
