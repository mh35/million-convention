class IdolsController < ApplicationController
  before_action :require_admin, except: [:show]
  def show
    begin
      @idol = Idol.find(params[:id])
      @threads = @idol.idol_threads.order(thread_num: 'DESC')
      @title = @idol.name + ' - コンベンションセンター'
      if @threads.empty?
        @can_create_thread = true
      elsif @threads.first.thread_responses.length >= 900
        @can_create_thread = true
      else
        @can_create_thread = false
      end
      @idol_thread = IdolThread.new
      @idol_thread.idol = @idol
    rescue
      redirect_to controller: 'top', action: 'index'
    end
  end

  def new
    @idol = Idol.new
    @title = 'アイドル新規作成 - コンベンションセンター'
  end

  def create
    @idol = Idol.new(params[:idol].permit(:name, :idol_num, :icon_url))
    @idol.save
    redirect_to action: 'show', id: @idol.id
  end

  def edit
    begin
      @idol = Idol.find(params[:id])
      @title = @idol.name + 'を編集 - コンベンションセンター'
    rescue
      redirect_to controller: 'top', action: 'index'
    end
  end

  def update
    begin
      @idol = Idol.find(params[:id])
      @idol.name = params[:idol][:name]
      @idol.idol_num = params[:idol][:idol_num]
      @idol.icon_url = params[:idol][:icon_url]
      @idol.save
      redirect_to action: 'show', id: @idol.id
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
