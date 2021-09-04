# frozen_string_literal: true

module UwoBotCore
  module Infrastructure
    module Factories
      class WordSimpleFactory
        def create_new_word(name, type, description)
          Domain::Entities::Word.new(name, type, description)
        end
      end
    end
  end
end
