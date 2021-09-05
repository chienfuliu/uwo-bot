# frozen_string_literal: true

require 'ed25519'
require 'i18n'
require 'json'
require 'time'
require 'tzinfo'
require 'uwo_bot_core'

require 'uwo_bot_lambda/version'

require 'uwo_bot_lambda/repositories/price_tag_repository'
require 'uwo_bot_lambda/repositories/word_repository'

require 'uwo_bot_lambda/view_models/price_tag'
require 'uwo_bot_lambda/view_models/word'

require 'uwo_bot_lambda/presenters/base'
require 'uwo_bot_lambda/presenters/deregister_word_presenter'
require 'uwo_bot_lambda/presenters/query_price_tags_presenter'
require 'uwo_bot_lambda/presenters/query_words_presenter'
require 'uwo_bot_lambda/presenters/register_price_tag_presenter'
require 'uwo_bot_lambda/presenters/register_word_presenter'

require 'uwo_bot_lambda/controllers/base'
require 'uwo_bot_lambda/controllers/price_tags_controller'
require 'uwo_bot_lambda/controllers/words_controller'

require 'uwo_bot_lambda/response'
require 'uwo_bot_lambda/request'
require 'uwo_bot_lambda/configuration'

module UwoBotLambda
  extend Configuration
end
