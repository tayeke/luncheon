class ApplicationController < ActionController::Base
  protect_from_forgery

  def clearOldLunches
    # Lunch.where('start_time <= ?', Time.now.midnight).destroy_all
  end

end
