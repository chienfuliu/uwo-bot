# frozen_string_literal: true

I18n.config.available_locales = %i[en zh-tw]
I18n.load_path += Dir[File.expand_path('../locales/**/*.yml', __dir__)]
I18n.default_locale = :en
