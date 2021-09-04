# frozen_string_literal: true

require 'discordrb'
require 'erb'
require 'mongo'
require 'i18n'
require 'uwo_bot_core'
require 'yaml'

require 'uwo_bot_service/version'

require 'uwo_bot_service/repositories/word_repository'

require 'uwo_bot_service/view_models/word'

require 'uwo_bot_service/presenters/base'
require 'uwo_bot_service/presenters/deregister_word_presenter'
require 'uwo_bot_service/presenters/query_words_presenter'
require 'uwo_bot_service/presenters/register_word_presenter'

require 'uwo_bot_service/controllers/words_controller'

require 'uwo_bot_service/bot_service'
