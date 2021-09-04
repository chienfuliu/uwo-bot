# frozen_string_literal: true

COMMAND_PREFIX = '!'

COMMAND_OPTIONS = {
  ask: {
    description: I18n.t('commands.ask.description'),
    usage: 'ask [type_]name',
    min_args: 1,
    max_args: 1,
    controller: UwoBotService::Controllers::WordsController,
  },
  learn: {
    description: I18n.t('commands.learn.description'),
    usage: 'learn [type_]name description',
    min_args: 2,
    required_roles: Array(ENV['TRAINER_ROLE']),
    permission_message:
      I18n.t('commands.common.no_permission', command: '%name%'),
    controller: UwoBotService::Controllers::WordsController,
  },
  forget: {
    description: I18n.t('commands.forget.description'),
    usage: 'forget [type_]name',
    min_args: 1,
    max_args: 1,
    required_roles: Array(ENV['TRAINER_ROLE']),
    permission_message:
      I18n.t('commands.common.no_permission', command: '%name%'),
    controller: UwoBotService::Controllers::WordsController,
  },
}.freeze
