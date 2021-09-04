# frozen_string_literal: true

version = File.read(File.expand_path('../VERSION', __dir__)).strip

Gem::Specification.new do |s|
  s.name                  = 'uwo_bot_core'
  s.version               = version
  s.summary               = 'Library of UWO bot.'
  s.authors               = ['Chien-Fu Liu']
  s.homepage              = 'https://github.com/chienfuliu/uwo-bot'
  s.license               = 'MIT'

  s.files                 = Dir['lib/**/*']
  s.require_paths         = ['lib']
  s.required_ruby_version = Gem::Requirement.new('>= 2.3.0')
end
