class AddCreatorToLunch < ActiveRecord::Migration
  def change
    add_column :lunches, :creator, :string
  end
end
