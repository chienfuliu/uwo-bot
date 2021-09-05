# frozen_string_literal: true

module UwoBotLambda
  module Configuration
    SUPPORTED_CONFIGS = {
      locale: :en,
      timezone: 'UTC',
      discord_app: {
        public_key: nil,
      },
      factories: {
        price: nil,
        price_tag: nil,
        word: nil,
      },
      repositories: {
        price_tag: nil,
        word: nil,
      },
    }.freeze

    private_constant :SUPPORTED_CONFIGS

    def configure
      yield config if block_given?
    end

    def config
      return @config if @config

      converter = lambda do |c|
        c = c.transform_values { |v| v.is_a?(Hash) ? converter.call(v) : v }
        Struct.new(*c.keys).new(*c.values)
      end

      @config = converter.call(SUPPORTED_CONFIGS)
    end
  end
end
