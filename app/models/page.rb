class Page < ActiveRecord::Base
	has_many :components, dependent: :destroy
  belongs_to :user

end
