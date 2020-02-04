# frozen_string_literal: true

module Same
  module Interactor
    # Module allows to define required and optional attributes which interact accepts.
    module ContextAttributes
      NOT_SET = Object.new

      extend ActiveSupport::Concern

      class_methods do
        attr_writer :required_context_attributes

        def required_context_attributes
          @required_context_attributes ||= []
        end

        def context_attr(*fields, default: NOT_SET, optional: false)
          optional ||= default != NOT_SET

          define_field_methods(fields, default: default)

          if optional
            self.required_context_attributes -= fields.map(&:to_sym)
          else
            self.required_context_attributes += fields.map(&:to_sym)
          end
        end

        private

        def define_field_methods(fields, default:)
          fields.each do |field|
            define_method field do
              if context.to_h.include?(field.to_sym) || default == NOT_SET
                context.public_send(field)
              else
                default
              end
            end
          end
        end
      end

      included do
        before :assert_context_attributes
      end

      def assert_context_attributes
        keys = context.to_h.keys.map(&:to_sym)
        required_attributes = self.class.required_context_attributes.sort

        return if (required_attributes & keys).sort == required_attributes

        missing_keys = required_attributes - keys
        raise(
          MissingAttributeError,
          "Context attributes are missing. Missing attributes are: #{missing_keys.inspect}"
        )
      end
    end
  end
end
