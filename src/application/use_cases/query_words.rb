# frozen_string_literal: true

require_relative 'base'

module UwoDictionaryBot
  module Application
    module UseCases
      class QueryWords < Base
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

          # Not specifying the type to find all approximate words.
          words = @word_repository.query(name: name).to_a
          word = extract_exact_word!(words, type)

          if word.nil? && words.empty?
            @presenter&.word_not_found
            return
          end

          # As long as one or more results are matched, no matter exact one or
          # approximate ones, consider the query as successful and leave the
          # rendering logic to the presenter.
          @presenter&.ok(word, words, with_type: !type.nil?)
        rescue Errors::ArgumentBlankError
          @presenter&.argument_invalid
        end

        private

        def extract_exact_word!(words, type)
          index_of_exact_word = words.find_index { |w| w.type == type }
          return nil unless index_of_exact_word

          words.slice!(index_of_exact_word)
        end
      end
    end
  end
end
