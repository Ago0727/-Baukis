class Staff::BASE < ApplicationController
  private
  before_action :authorize
  def current_staff_member
    if session[:staff_member_id]
      @current_staff_member ||=
          StaffMember.find_by(id: session[:staff_member_id])
    end
  end

  helper_method :current_staff_member
  def authorize
    unless current_staff_member
      flash.alert = '職員としてログインしてください'
      redirect_to :staff_login and return
    end
  end

  def check_account
    if current_staff_member && !current_staff_member.active?
      session.delete(:staff_member_id)
      flash.alert = 'アカウントが無効になりました.'
      redirect_to :staff_root
    end
  end

  TIMEOUT = 60.minutes

  def check_timeout
    if current_staff_member
      if session[:last_access_time] >= TIMEOUT.ago
        session[:last_access_time] = time.current
      else
        session.delete(:staff_member_id)
        flash.alert = 'セッションがタイムアウトになりました.'
        redirect_to :staff_login
      end

    end
  end
end