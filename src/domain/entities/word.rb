# frozen_string_literal: true

module UwoDictionaryBot
  module Domain
    module Entities
      class Word
        attr_reader :name, :type, :description

        def initialize(name, type, description)
          @name = name
          @type = type
          @description = description
        end
      end
    end
  end
end
