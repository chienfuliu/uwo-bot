# frozen_string_literal: true

module UwoBotLambda
  class Request
    SUPPORTED_OPTION_TYPES = [
      1, # SUB_COMMAND
      2, # SUB_COMMAND_GROUP
      3, # STRING
      4, # INTEGER
      5, # BOOLEAN
    ].freeze

    HANDLER_MAPPING = {
      %w[ask price] => [Controllers::PriceTagsController, :ask],
      %w[learn price] => [Controllers::PriceTagsController, :learn],

      %w[ask word] => [Controllers::WordsController, :ask],
      %w[learn word] => [Controllers::WordsController, :learn],
      %w[forget word] => [Controllers::WordsController, :forget],
    }.freeze

    private_constant :HANDLER_MAPPING

    def initialize(headers:, body:)
      @headers = headers
      @raw_body = body
      @body = JSON.parse(body)
    end

    def call
      return Response.unauthenticated unless authenticated?
      return Response.pong if ping?

      load_initializers

      messages = []
      messenger = ->(message) { messages << message }

      controller_class, action, params = handler_with_params
      I18n.with_locale(UwoBotLambda.config.locale) do
        controller_class.new(messenger: messenger).public_send(action, params)
      end

      Response.from_message(messages.join("\n"))
    rescue StandardError => e
      puts e.class.name
      puts e.message
      puts e.backtrace
      Response.error
    end

    def authenticated?
      signature = @headers['x-signature-ed25519']
      timestamp = @headers['x-signature-timestamp']
      return false if [signature, timestamp].any? { |v| v.to_s.strip.empty? }

      signature = signature.scan(/../).map(&:hex).pack('c*')
      return false unless signature.size == Ed25519::SIGNATURE_SIZE

      discord_app_key = UwoBotLambda.config.discord_app.public_key
      public_key = discord_app_key.scan(/../).map(&:hex).pack('c*')
      verify_key = Ed25519::VerifyKey.new(public_key)

      verify_key.verify(signature, timestamp + @raw_body)
    rescue Ed25519::VerifyError
      false
    end

    def ping?
      @body['type'] == 1
    end

    private

    def handler_with_params
      HANDLER_MAPPING.each do |dig_keys, handler|
        params = processed_data.dig(*dig_keys)
        return *handler, params if params
      end
    end

    # { 'ask' => { 'word' => { 'name' => 'name1', type => 'type1' } } }
    def processed_data
      return @processed_data if @processed_data

      name, options = @body['data'].values_at('name', 'options')
      options = options&.map { |o| to_name_value_pair(o) }.to_h
      @processed_data = { name => options }
    end

    def to_name_value_pair(option)
      raise unless SUPPORTED_OPTION_TYPES.include?(option['type'])
      return option.values_at('name', 'value') unless option.key?('options')

      [option['name'], option['options'].map { |o| to_name_value_pair(o) }.to_h]
    end

    def load_initializers
      initializer_files = File.join('config', 'initializers', '**', '*.rb')
      Dir[initializer_files, base: __dir__].sort.each do |file|
        require_relative file
      end
    end
  end
end
