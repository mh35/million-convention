class TopController < ApplicationController
  def index
    @idols = Idol.order('idol_num')
  end
end
