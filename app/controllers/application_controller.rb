class ApplicationController < ActionController::Base
  protect_from_forgery

  def redis
    @redis ||= Redis.new(:timeout => 0)
  end

end
