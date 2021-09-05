# frozen_string_literal: true

module UwoBotLambda
  module Repositories
    class PriceTagRepository
      TABLE_NAME = 'price_tags'
      UNTYPED_SYMBOL = '~'

      def initialize(client)
        @client = client
      end

      def query(**conditions)
        allowed_conditions = %i[name type]
        conditions.select! { |key, _value| allowed_conditions.include?(key) }

        conditions = convert_to_query_condition(**conditions)
        @client.query(conditions).items.map { |i| to_entity(i) }
      end

      def find(**conditions)
        allowed_conditions = %i[name type]
        conditions.select! { |key, _value| allowed_conditions.include?(key) }

        conditions = convert_to_query_condition(**conditions)
        @client.query(conditions).items.first.yield_self { |i| to_entity(i) }
      end

      def register(price_tag)
        @client.put_item(
          table_name: TABLE_NAME,
          item: {
            name: price_tag.name,
            type: price_tag.type || UNTYPED_SYMBOL,
            prices: price_tag.prices.map do |p|
              {
                value: p.value,
                registered_at: p.registered_at.iso8601,
              }
            end.to_json,
          }
        )

        true
      rescue RuntimeError
        false
      end

      private

      def convert_to_query_condition(**conditions)
        {
          table_name: TABLE_NAME,
          key_condition_expression:
            conditions.keys.map { |key| "##{key} = :#{key}" }.join(' AND '),
          expression_attribute_names:
            conditions.keys.map { |key| ["##{key}", key] }.to_h,
          expression_attribute_values:
            conditions.transform_keys { |key| ":#{key}" },
        }
      end

      def to_entity(item)
        return nil unless item

        prices = JSON.parse(item['prices']).map do |i|
          UwoBotLambda.config.factories.price.create(
            i['value'],
            i['registered_at']
          )
        end

        UwoBotLambda.config.factories.price_tag.create(
          item['name'],
          item['type'] == UNTYPED_SYMBOL ? nil : item['type'],
          prices
        )
      end
    end
  end
end
