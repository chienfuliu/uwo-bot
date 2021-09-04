# frozen_string_literal: true

module UwoBotLambda
  module Controllers
    class Base
      def initialize(*); end

      private

      def word_repository
        UwoBotLambda.config.repositories.word
      end

      def word_factory
        UwoBotLambda.config.factories.word
      end
    end
  end
end
