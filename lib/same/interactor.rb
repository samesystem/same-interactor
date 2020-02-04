# frozen_string_literal: true

require 'same/interactor/version'

module Same
  # Interactor with validations and context attributes
  module Interactor
    require 'active_support'
    require 'active_model'
    require 'interactor'
    require_relative 'interactor/context_attributes'
    require_relative 'interactor/validations'

    class Error < StandardError; end
    class MissingAttributeError < Error; end

    extend ActiveSupport::Concern

    included do
      include ::Interactor
      include Interactor::ContextAttributes
      include Interactor::Validations
    end
  end
end
