class StreamController < ApplicationController
  
  def connect
    socket = ESHQ.open :channel => params[:channel]
    render :json => {:socket => socket}
  end

end
