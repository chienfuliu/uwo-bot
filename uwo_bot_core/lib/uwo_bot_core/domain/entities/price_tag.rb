# frozen_string_literal: true

module UwoBotCore
  module Domain
    module Entities
      class PriceTag
        CONTAINER_SIZE = 5

        attr_reader :name, :type, :prices

        def initialize(name, type, prices = nil)
          @name = name
          @type = type
          @prices = allocate_prices(Array(prices))
        end

        def update_price(price_value, registered_at: nil)
          price = Price.new(price_value, registered_at || Time.now.utc)
          @prices = allocate_prices(@prices + [price])
        end

        private

        def allocate_prices(prices)
          prices.sort_by(&:registered_at).reverse.take(CONTAINER_SIZE).freeze
        end
      end
    end
  end
end
