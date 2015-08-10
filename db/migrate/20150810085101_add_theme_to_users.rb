class AddThemeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :theme, :string, default: "default"
  end
end
