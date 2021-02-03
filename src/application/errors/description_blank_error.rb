# frozen_string_literal: true

require_relative 'argument_blank_error'

module UwoDictionaryBot
  module Application
    module Errors
      class DescriptionBlankError < ArgumentBlankError
      end
    end
  end
end
