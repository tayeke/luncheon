class Person < ActiveRecord::Base
  attr_accessible :fb_id, :name

  validates_uniqueness_of :fb_id

  has_and_belongs_to_many :lunches

end
