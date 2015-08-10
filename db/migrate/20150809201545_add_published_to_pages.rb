class AddPublishedToPages < ActiveRecord::Migration
  def change
    add_column :pages, :published, :integer
  end
end
