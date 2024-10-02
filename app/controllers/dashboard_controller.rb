class DashboardController < ApplicationController
  before_action :authenticate_user!
  def show
    @transcriptions_count = current_user.transcriptions.count
  end
end
