class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  validates :name, uniqueness: true
  devise :database_authenticatable, :registerable,
       	 :recoverable, :rememberable, :trackable, :validatable, :zxcvbnable
  has_many :pages, dependent: :destroy
  has_many :images, dependent: :destroy
  before_save :set_default_role

  def role?(role_name)
  	role == role_name
  end

  private
  def set_default_role
    self.role ||= "user"
  end

end
