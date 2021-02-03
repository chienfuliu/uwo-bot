# frozen_string_literal: true

require_relative 'shared/argument_validatable'

module UwoDictionaryBot
  module Application
    module UseCases
      class Base
        include ArgumentValidatable
      end
    end
  end
end
