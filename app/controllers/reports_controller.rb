class ReportsController < ApplicationController
  before_action :require_login
  def create
    begin
      @user = User.find(session[:uid])
    rescue
      redirect_to controller: 'top', action: 'index'
      return
    end
    @report = Report.new(params[:report].permit(:thread_response_id))
    @report.user = @user
    @report.save
    begin
      redirect_to :back
    rescue
      @thread_response = @report.thread_response
      @idol_thread = @thread_response.idol_thread
      @idol = @idol_thread.idol
      redirect_to controller: 'idol_threads', action: 'show',
                  idol_id: @idol.id, id: @idol_thread.id
    end
  end
end
