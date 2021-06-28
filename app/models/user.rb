class User < ApplicationRecord
  resourcify
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable

  has_many :worlds
  belongs_to :selected_world, class_name: 'World', optional: true

  def name
    display_name
  end
end
