# frozen_string_literal: true

require 'i18n'

I18n.config.available_locales = %i[en zh-tw]
I18n.load_path += Dir[File.expand_path('../locales/**/*.yml', __dir__)]
I18n.default_locale = ENV.fetch('DISCORD_LANG', 'en').to_sym
