# frozen_string_literal: true

$LOAD_PATH << File.expand_path('lib', __dir__)

require 'aws-sdk-dynamodb'
require 'uwo_bot_lambda'

def lambda_handler(event:, context:)
  configure_bot
  request = UwoBotLambda::Request.new(
    headers: event['headers'],
    body: event['body']
  )

  response = request.call

  {
    statusCode: response.status_code,
    headers: response.headers,
    body: response.body,
  }
end

private

def configure_bot
  UwoBotLambda.configure do |config|
    config.locale = ENV['LOCALE']
    config.timezone = ENV['TIMEZONE']

    config.discord_app.public_key = ENV['PUBLIC_KEY']

    config.factories.price =
      UwoBotCore::Infrastructure::Factories::PriceSimpleFactory.new
    config.factories.price_tag =
      UwoBotCore::Infrastructure::Factories::PriceTagSimpleFactory.new
    config.factories.word =
      UwoBotCore::Infrastructure::Factories::WordSimpleFactory.new

    db_client = Aws::DynamoDB::Client.new
    config.repositories.price_tag =
      UwoBotLambda::Repositories::PriceTagRepository.new(db_client)
    config.repositories.word =
      UwoBotLambda::Repositories::WordRepository.new(db_client)
  end
end
