module ReducibleAssociation
  extend ActiveSupport::Concern

  module ClassMethods
    def add_reducer(association, reduce_op, label)
      define_method :"#{label}_#{association}" do |attr, original = 0|
        send(association).map(&attr).reduce(original, reduce_op)
      end
    end
  end
end
