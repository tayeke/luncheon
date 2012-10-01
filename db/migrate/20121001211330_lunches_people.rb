class LunchesPeople < ActiveRecord::Migration
  def up
    create_table 'lunches_people', :id => false do |t|
      t.column :person_id, :integer
      t.column :lunch_id,  :integer
    end
  end

  def down
    drop_table 'lunches_people'
  end
end
