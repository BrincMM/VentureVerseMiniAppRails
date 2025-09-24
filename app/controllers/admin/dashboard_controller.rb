class Admin::DashboardController < ApplicationController
  before_action :authenticate_admin!
  layout "admin"

  def index
    @users_count = User.count
    @waiting_list_count = WaitingList.count
  end
end
