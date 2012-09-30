class AddStartTimeToLunches < ActiveRecord::Migration
  def change
    add_column :lunches, :start_time, :datetime
  end
end
