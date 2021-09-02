# frozen_string_literal: true

require_relative 'base'

module UwoDictionaryBot
  module Application
    module UseCases
      class DeregisterWord < Base
        attr_writer :presenter

        def initialize(word_repository, **options)
          super()
          @word_repository = word_repository
          @presenter = options[:presenter]
        end

        def call(name, type)
          name = normalize_key(name)
          type = normalize_key(type)

          validate_presence_of('name', value: name)
          validate_presence_of('type', value: type, allow_nil: true)

          word = @word_repository.find(name: name, type: type)
          unless word
            @presenter&.word_not_found
            return
          end

          unless @word_repository.deregister(word)
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
