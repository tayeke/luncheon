class Lunch < ActiveRecord::Base
  attr_accessible :place, :start_time
  after_save :update_clients

  def update_clients
    ESHQ.send :channel => "lunch-channel", :data => self.to_json, :type => "message"
  end

end
