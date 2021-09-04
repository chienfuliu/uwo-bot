# frozen_string_literal: true

version = File.read(File.expand_path('VERSION', __dir__)).strip

Gem::Specification.new do |s|
  s.name                  = 'uwo_bot'
  s.version               = version
  s.summary               = 'Library of UWO bot.'
  s.authors               = ['Chien-Fu Liu']
  s.homepage              = 'https://github.com/chienfuliu/uwo-bot'
  s.license               = 'MIT'

  s.files                 = ['README.md']
  s.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  s.add_runtime_dependency 'uwo_bot_core', version
  s.add_runtime_dependency 'uwo_bot_service', version
end
