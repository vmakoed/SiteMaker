class Component < ActiveRecord::Base
	belongs_to :page
	self.inheritance_column = :content_type
end
