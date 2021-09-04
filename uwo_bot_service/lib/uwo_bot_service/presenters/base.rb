# frozen_string_literal: true

module UwoBotService
  module Presenters
    class Base
      def initialize(messenger)
        @messenger = messenger
      end
    end
  end
end
