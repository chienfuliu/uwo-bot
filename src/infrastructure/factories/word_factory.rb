# frozen_string_literal: true

require_relative '../../domain/entities/word'

module UwoDictionaryBot
  module Infrastructure
    module Factories
      class WordFactory
        def create_new_word(name, type, description)
          Domain::Entities::Word.new(name, type, description)
        end
      end
    end
  end
end
