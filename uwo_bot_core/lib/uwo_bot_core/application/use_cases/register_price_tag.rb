# frozen_string_literal: true

module UwoBotCore
  module Application
    module UseCases
      class RegisterPriceTag < Base
        attr_writer :presenter

        def initialize(price_tag_repository, price_tag_factory, **options)
          super()
          @price_tag_repository = price_tag_repository
          @price_tag_factory = price_tag_factory
          @presenter = options[:presenter]
        end

        def call(name, type, price_value)
          name = normalize_key(name)
          type = normalize_key(type)

          validate_presence_of(name)
          validate_presence_of(type, allow_nil: true)
          validate_presence_of(price_value)

          price_tag = @price_tag_repository.find(name: name, type: type) ||
                      @price_tag_factory.create(name, type)

          price_tag.update_price(price_value)

          unless @price_tag_repository.register(price_tag)
            @presenter&.update_failed
            return
          end

          @presenter&.ok(price_tag)
        rescue Errors::ArgumentBlankError
          @presenter&.argument_invalid
        rescue StandardError => e
          puts e.class.name
          puts e.message
          puts e.backtrace
          @presenter&.update_failed
        end
      end
    end
  end
end
