# frozen_string_literal: true

module UwoBotLambda
  module Presenters
    class Base
      def initialize(messenger)
        @messenger = messenger
      end
    end
  end
end
