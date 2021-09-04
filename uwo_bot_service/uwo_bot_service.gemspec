# frozen_string_literal: true

version = File.read(File.expand_path('../VERSION', __dir__)).strip

Gem::Specification.new do |s|
  s.name                  = 'uwo_bot_service'
  s.version               = version
  s.summary               = 'Discord bot service for UWO.'
  s.authors               = ['Chien-Fu Liu']
  s.homepage              = 'https://github.com/chienfuliu/uwo-bot'
  s.license               = 'MIT'

  s.files                 = Dir['exe/**/*', 'lib/**/*']
  s.require_paths         = ['lib']
  s.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  s.bindir                = 'exe'
  s.executables           = s.files.grep(%r{^exe/}) { |f| File.basename(f) }

  s.add_runtime_dependency 'discordrb', '~> 3.4.0'
  s.add_runtime_dependency 'i18n', '~> 1.8', '>= 1.8.8'
  s.add_runtime_dependency 'mongo', '~> 2.14.0'
  s.add_runtime_dependency 'uwo_bot_core', version
end
