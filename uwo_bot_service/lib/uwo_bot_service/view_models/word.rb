# frozen_string_literal: true

module UwoBotService
  module ViewModels
    class Word
      attr_reader :description

      def initialize(word_entity)
        @name = word_entity.name
        @type = word_entity.type
        @description = word_entity.description
      end

      def display_name
        typed? ? "#{@type}_#{@name}" : @name
      end

      def typed?
        !@type.nil?
      end
    end
  end
end
