# frozen_string_literal: true

module UwoBotCore
  module Domain
    module Entities
      class Price
        attr_reader :value, :registered_at

        def initialize(value, registered_at)
          @value = value
          @registered_at = parse_time(registered_at).utc
        end

        private

        def parse_time(time)
          case time
          when Time
            time
          when String
            Time.iso8601(time)
          when Numeric
            Time.at(time)
          else
            raise ArgumentError, 'invalid time type'
          end
        end
      end
    end
  end
end
