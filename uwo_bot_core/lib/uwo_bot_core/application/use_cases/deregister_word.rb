# frozen_string_literal: true

module UwoBotCore
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

          validate_presence_of(name)
          validate_presence_of(type, allow_nil: true)

          word = @word_repository.find(name: name, type: type)
          unless word
            @presenter&.not_found
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
