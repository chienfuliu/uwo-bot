# frozen_string_literal: true

require_relative '../../errors/description_blank_error'
require_relative '../../errors/name_blank_error'
require_relative '../../errors/type_blank_error'

module UwoDictionaryBot
  module Application
    module UseCases
      module ArgumentValidatable
        BLANK_ERROR_MAPPING = {
          'name' => Errors::NameBlankError,
          'type' => Errors::TypeBlankError,
          'description' => Errors::DescriptionBlankError,
        }.freeze

        private_constant :BLANK_ERROR_MAPPING

        module_function

        def normalize_key(arg)
          return nil if arg.nil?

          arg.to_s.downcase.strip
        end

        def validate_presence_of(name, value:, allow_nil: false)
          return if value.nil? && allow_nil
          return unless value.to_s.strip.empty?

          error_type = BLANK_ERROR_MAPPING.fetch(name)
          raise error_type, "#{name} cannot be blank"
        end
      end
    end
  end
end
