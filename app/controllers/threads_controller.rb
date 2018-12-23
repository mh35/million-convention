class ThreadsController < ApplicationController
  before_action :require_login, only: [:create]
  def create
    begin
      @idol = Idol.find(params[:idol_id])
      @user = User.find(session[:uid])
    rescue
      redirect_to controller: 'top', action: 'index'
      return
    end
    if @user.last_thread_created_at && @user.last_thread_created_at >
                                       Time.now - 600
      flash[:error_msg] = 'スレッドを直前に立てすぎです'
      redirect_to controller: 'idols', action: 'show', id: @idol.id
      return
    end
    if @user.last_wrote_at && @user.last_wrote_at > Time.now - 180
      flash[:error_msg] = 'あなたは直前にどこかに書き込んでます'
      redirect_to controller: 'idols', action: 'show', id: @idol.id
      return
    end
    if @user.banned
      flash[:error_msg] = 'あなたは書き込みが禁止されています'
      redirect_to controller: 'idols', action: 'show', id: @idol.id
      return
    end
    if params[:idol_thread][:name].length > 32
      flash[:error_msg] = 'スレッド名は32文字以内にしてください'
      redirect_to controller: 'idols', action: 'show', id: @idol.id
      return
    end
    begin
      ActiveRecord::Base.transaction do
        @thread = IdolThread.new(params[:idol_thread].permit(:name))
        @thread.thread_num = @idol.idol_threads.length + 1
        @thread.idol = @idol
        @thread.save!
      end
    rescue
      redirect_to controller: 'idols', action: 'show', id: @idol.id
      return
    end
    redirect_to controller: 'idols', action: 'show', id: @idol.id
  end

  def show
    begin
      @idol = Idol.find(params[:idol_id])
    rescue
      redirect_to controller: 'top', action: 'index'
      return
    end
  end
end