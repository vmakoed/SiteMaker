class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
    	t.string :title
      t.references :user
      t.timestamps null: false
    end
  end
end
