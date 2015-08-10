class CreateComponents < ActiveRecord::Migration
  def change
    create_table :components do |t|
    	t.string :content_type
      t.integer :order
      t.text :content
      t.references :page
      t.timestamps null: false
    end
  end
end
