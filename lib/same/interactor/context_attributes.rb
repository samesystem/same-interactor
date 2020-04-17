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
              @context_attribute_value ||= {}
              return @context_attribute_value[field] if @context_attribute_value.key?(field)

              @context_attribute_value[field] = fetch_context_method_value(field, default)
            end
          end
        end
      end

      included do
        before :assert_context_attributes
      end

      def fetch_context_method_value(field, default)
        if context.to_h.include?(field.to_sym) || default == NOT_SET
          context.public_send(field)
        elsif default.is_a?(Proc)
          instance_exec(&default)
        else
          default
        end
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
