class DataStream < Sinatra::Base

  get '/stream', :provides => 'text/event-stream' do
    stream :keep_open do |out|
      redis.subscribe('events', 'out') do |on|
        on.message do |channel, msg|
          out << "data: #{msg}\n\n"
        end
      end
      out.callback { redis.unsubscribe }
      out.errback do
        logger.warn "lost connection"
        redis.unsubscribe
      end
    end
  end

  def redis
    if Rails.env.production?
      uri = URI.parse(ENV["REDISTOGO_URL"])
      @redis ||= Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
    else
      @redis ||= Redis.new()
    end
  end

end