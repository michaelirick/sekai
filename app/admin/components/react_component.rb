module Admin
  module Components
    class React < ActiveAdmin::Component
      class ReactComponentBuilder
        include ::React::Rails::ViewHelper
        include ActionView::Helpers::TagHelper
      end

      builder_method :react_component

      def to_s
        ReactComponentBuilder.new.react_component(*@args, &@block)
      end

      def build(*args, &block)
        @args = args
        @block = block
      end
    end
  end
end