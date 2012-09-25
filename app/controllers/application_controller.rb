class ApplicationController < ActionController::Base
  protect_from_forgery

  def redis
    if Rails.env.production?
      uri = URI.parse(ENV["REDISTOGO_URL"])
      @redis ||= Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
    else
      @redis ||= Redis.new()
    end
  end

end
