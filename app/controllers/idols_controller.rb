class IdolsController < ApplicationController
  before_action :require_admin, except: [:show]
  def show
    begin
      @idol = Idol.find(params[:id])
    rescue
      redirect_to controller: 'top', action: 'index'
    end
  end

  def new
    @idol = Idol.new
  end

  def create
    params[:user].permit(:name, :idol_num, :icon_url)
    @idol = Idol.new(params[:idol])
    @idol.save
    redirect_to action: 'show', id: @idol.id
  end

  def edit
    begin
      @idol = Idol.find(params[:id])
    rescue
      redirect_to controller: 'top', action: 'index'
    end
  end

  def update
    begin
      @idol = Idol.find(params[:id])
    rescue
      redirect_to controller: 'top', action: 'index'
    end
  end

  def destroy
    begin
      @idol = Idol.find(params[:id])
    rescue
      redirect_to controller: 'top', action: 'index'
    end
    @idol.destroy
    redirect_to controller: 'top', action: 'index'
  end
end
