class ThreadResponsesController < ApplicationController
  before_action :require_login
  def create
    begin
      @idol = Idol.find(params[:idol_id])
      @idol_thread = @idol.idol_threads.find(params[:idol_thread_id])
      @user = User.find(session[:uid])
    rescue
      redirect_to controller: 'top', action: 'index'
      return
    end
    if @user.last_wrote_at && @user.last_wrote_at > Time.now - 180
      flash[:error_msg] = 'あなたは直前にどこかに書き込んでます'
      redirect_to controller: 'idol_threads', action: 'show',
                  idol_id: @idol.id, id: @idol_thread.id
      return
    end
    if @user.banned
      flash[:error_msg] = 'あなたは書き込みが禁止されています'
      redirect_to controller: 'idol_threads', action: 'show',
                  idol_id: @idol.id, id: @idol_thread.id
      return
    end
    if @idol_thread.thread_responses.length >= 1000
      flash[:error_msg] = '書き込みが1000に到達しました'
      redirect_to controller: 'idol_threads', action: 'show',
                  idol_id: @idol.id, id: @idol_thread.id
      return
    end
    begin
      ActiveRecord::Base.transaction do
        @res = ThreadResponse.new(params[:thread_response].permit(:content))
      end
    rescue
      redirect_to controller: 'idol_threads', action: 'show',
                  idol_id: @idol.id, id: @idol_thread.id
      return
    end
  end
end
