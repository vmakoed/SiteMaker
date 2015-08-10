class AddMenuOrientationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :menu_orientation, :string, default: "horizontal"
  end
end
