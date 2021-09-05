# frozen_string_literal: true

module UwoBotCore
  module Application
    module UseCases
      class QueryPriceTags < Base
        attr_writer :presenter

        def initialize(price_tag_repository, **options)
          super()
          @price_tag_repository = price_tag_repository
          @presenter = options[:presenter]
        end

        def call(name, type)
          name = normalize_key(name)
          type = normalize_key(type)

          validate_presence_of(name)
          validate_presence_of(type, allow_nil: true)

          # Not specifying the type to find all approximate price_tags.
          price_tags = @price_tag_repository.query(name: name).to_a
          price_tag = extract_exact_price_tag!(price_tags, type)

          if price_tag.nil? && price_tags.empty?
            @presenter&.not_found
            return
          end

          # As long as one or more results are matched, no matter exact one or
          # approximate ones, consider the query as successful and leave the
          # rendering logic to the presenter.
          @presenter&.ok(price_tag, price_tags, with_type: !type.nil?)
        rescue Errors::ArgumentBlankError
          @presenter&.argument_invalid
        end

        private

        def extract_exact_price_tag!(price_tags, type)
          index_of_exact_price_tag =
            price_tags.find_index { |p| p.type == type }
          return nil unless index_of_exact_price_tag

          price_tags.slice!(index_of_exact_price_tag)
        end
      end
    end
  end
end
