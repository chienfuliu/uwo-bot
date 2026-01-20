# frozen_string_literal: true

version = File.read(File.expand_path('../VERSION', __dir__)).strip

Gem::Specification.new do |s|
  s.name                  = 'uwo_bot_lambda'
  s.version               = version
  s.summary               = 'A serverless UWO bot function.'
  s.authors               = ['Chien-Fu Liu']
  s.homepage              = 'https://github.com/chienfuliu/uwo-bot'
  s.license               = 'MIT'

  s.files                 = Dir['lib/**/*']
  s.require_paths         = ['lib']
  s.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  s.add_runtime_dependency 'aws-sdk-dynamodb', '~> 1.160'
  s.add_runtime_dependency 'ed25519', '~> 1.2', '>= 1.2.4'
  s.add_runtime_dependency 'i18n', '~> 1.8', '>= 1.8.8'
  s.add_runtime_dependency 'tzinfo', '~> 2.0'
  s.add_runtime_dependency 'uwo_bot_core', version
end
