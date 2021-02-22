class Hex < ApplicationRecord
  belongs_to :province
  belongs_to :owner, class_name: 'State', optional: true
end
