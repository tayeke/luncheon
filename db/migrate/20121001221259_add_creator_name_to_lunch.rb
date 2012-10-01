class AddCreatorNameToLunch < ActiveRecord::Migration
  def change
    add_column :lunches, :creator_name, :string
  end
end
