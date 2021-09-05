# frozen_string_literal: true

module UwoBotCore
  module Infrastructure
    module Factories
      class PriceTagSimpleFactory
        def create(name, type, prices = nil)
          Domain::Entities::PriceTag.new(name, type, prices)
        end
      end
    end
  end
end
