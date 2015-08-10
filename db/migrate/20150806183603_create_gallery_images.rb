class CreateGalleryImages < ActiveRecord::Migration
  def change
    create_table :gallery_images do |t|
    	t.integer :order
    	t.text :link
    	t.references :gallery
      t.timestamps null: false
    end
  end
end
