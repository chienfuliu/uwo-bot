# frozen_string_literal: true

module UwoBotService
  module Repositories
    class WordRepository
      def initialize(client)
        @client = client
        @words = @client[:words]
      end

      def query(**conditions)
        allowed_conditions = %i[name type]
        conditions.select! { |key, _value| allowed_conditions.include?(key) }

        @words.find(conditions).map { |r| to_entity(r) }
      end

      def find(**conditions)
        allowed_conditions = %i[name type]
        conditions.select! { |key, _value| allowed_conditions.include?(key) }

        @words.find(conditions).limit(1).first.yield_self { |r| to_entity(r) }
      end

      def register(word)
        result = @words.replace_one(
          { name: word.name, type: word.type },
          { name: word.name, type: word.type, description: word.description },
          upsert: true
        )
        result.successful?
      end

      def deregister(word)
        result = @words.delete_one({ name: word.name, type: word.type })
        result.successful?
      end

      private

      def to_entity(row)
        return nil unless row

        factory = UwoBotCore::Infrastructure::Factories::WordSimpleFactory.new
        factory.create(
          row['name'],
          row['type'],
          row['description']
        )
      end
    end
  end
end
