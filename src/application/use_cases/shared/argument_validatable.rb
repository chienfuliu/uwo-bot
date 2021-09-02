# frozen_string_literal: true

require_relative '../../errors/argument_blank_error'

module UwoDictionaryBot
  module Application
    module UseCases
      module ArgumentValidatable
        module_function

        def normalize_key(arg)
          return nil if arg.nil?

          arg.to_s.downcase.strip
        end

        def validate_presence_of(value, allow_nil: false)
          return if value.nil? && allow_nil
          return unless value.to_s.strip.empty?

          raise Errors::ArgumentBlankError
        end
      end
    end
  end
end
