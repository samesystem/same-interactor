# frozen_string_literal: true

module Same
  module Interactor
    # Module allows to define validations on interactor.
    module Validations
      extend ActiveSupport::Concern

      included do
        include ActiveModel::Validations

        around :validate_and_call
      end

      def validate_and_call(interactor)
        if valid?
          interactor.call
        else
          call_on_failure
        end
      end

      protected

      def call_on_failure
        context.fail!(fail_params)
      end

      def fail_params
        { errors: errors }
      end
    end
  end
end
