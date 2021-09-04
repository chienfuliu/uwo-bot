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
    config.locale = :'zh-tw'
    config.factories.word =
      UwoBotCore::Infrastructure::Factories::WordSimpleFactory.new
    config.repositories.word =
      UwoBotLambda::Repositories::WordRepository.new(Aws::DynamoDB::Client.new)
  end
end
