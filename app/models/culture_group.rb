class CultureGroup < ApplicationRecord
  belongs_to :parent, class_name: 'Culture'
  belongs_to :child, class_name: 'Culture'
end
