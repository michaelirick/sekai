class Role < ApplicationRecord
  has_and_belongs_to_many :users, :join_table => :users_roles
  
  belongs_to :resource,
             :polymorphic => true,
             :optional => true
  

  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true

  scopify

  def name
    if resource
      "#{self[:name]}::#{resource_type}::#{resource.id} '#{resource&.name}'"
    else
      self[:name]
    end
  end
end
