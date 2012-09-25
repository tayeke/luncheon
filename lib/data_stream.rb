class DataStream < Sinatra::Base

  get '/stream', :provides => 'text/event-stream' do
    stream :keep_open do |out|
      REDIS.subscribe('events', 'out') do |on|
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

end