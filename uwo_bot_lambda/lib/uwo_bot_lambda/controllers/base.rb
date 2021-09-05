# frozen_string_literal: true

module UwoBotLambda
  module Controllers
    class Base
      def initialize(*); end

      private

      def price_tag_repository
        UwoBotLambda.config.repositories.price_tag
      end

      def word_repository
        UwoBotLambda.config.repositories.word
      end

      def price_factory
        UwoBotLambda.config.factories.price
      end

      def price_tag_factory
        UwoBotLambda.config.factories.price_tag
      end

      def word_factory
        UwoBotLambda.config.factories.word
      end
    end
  end
end
