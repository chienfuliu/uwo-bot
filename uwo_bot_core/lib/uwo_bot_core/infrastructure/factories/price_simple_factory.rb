# frozen_string_literal: true

module UwoBotCore
  module Infrastructure
    module Factories
      class PriceSimpleFactory
        def create(value, registered_at)
          Domain::Entities::Price.new(value, registered_at)
        end
      end
    end
  end
end
