# frozen_string_literal: true

module UwoBotLambda
  module Repositories
    class WordRepository
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

      def register(word)
        @client.put_item(
          table_name: 'words',
          item: {
            name: word.name,
            type: word.type || UNTYPED_SYMBOL,
            description: word.description,
          }
        )

        true
      rescue RuntimeError
        false
      end

      def deregister(word)
        @client.delete_item(
          table_name: 'words',
          key: {
            name: word.name,
            type: word.type || UNTYPED_SYMBOL,
          }
        )

        true
      rescue RuntimeError
        false
      end

      private

      def convert_to_query_condition(**conditions)
        {
          table_name: 'words',
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

        UwoBotLambda.config.factories.word.create(
          item['name'],
          item['type'] == UNTYPED_SYMBOL ? nil : item['type'],
          item['description']
        )
      end
    end
  end
end
