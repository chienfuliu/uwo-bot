# frozen_string_literal: true

require_relative 'base'

module UwoDictionaryBot
  module Application
    module UseCases
      class RegisterWord < Base
        attr_writer :presenter

        def initialize(word_repository, word_factory, **options)
          super()
          @word_repository = word_repository
          @word_factory = word_factory
          @presenter = options[:presenter]
        end

        def call(name, type, description)
          name = normalize_key(name)
          type = normalize_key(type)

          validate_presence_of('name', value: name)
          validate_presence_of('type', value: type, allow_nil: true)
          validate_presence_of('description', value: description)

          word = @word_factory.create_new_word(name, type, description)
          unless @word_repository.register(word)
            @presenter&.update_failed
            return
          end

          @presenter&.ok(word)
        rescue Errors::ArgumentBlankError
          @presenter&.argument_invalid
        end
      end
    end
  end
end
