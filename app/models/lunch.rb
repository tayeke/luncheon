class Lunch < ActiveRecord::Base
  attr_accessible :place, :start_time, :creator, :creator_name
  after_save :update_clients

  has_and_belongs_to_many :people
  validates_associated :people

  before_destroy :clear_records

  def clear_records
    self.people.clear
  end

  def update_clients
    ESHQ.send :channel => "lunch-channel", :data => self.to_json(:include => :people), :type => "message"
  end

end
