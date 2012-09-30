class StreamController < ApplicationController
  
  def connect
    socket = ESHQ.open :channel => params[:channel]
    
    content_type :json
    {:socket => socket}.to_json
  end

end
