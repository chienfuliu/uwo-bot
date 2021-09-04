# frozen_string_literal: true

module UwoBotLambda
  class Response
    attr_reader :status_code, :headers, :body

    def initialize(status_code, headers: nil, body: nil)
      @status_code = status_code
      return unless body

      @headers = headers || {}
      @headers['content-type'] = 'application/json'
      @body = JSON.generate(body)
    end

    def self.pong
      new(200, body: { 'type' => 1 })
    end

    def self.from_message(message)
      return new(200, body: { 'type' => 4 }) if message.to_s.strip.empty?

      new(200, body: { 'type' => 4, 'data' => { 'content' => message.to_s } })
    end

    def self.error
      new(400)
    end

    def self.unauthenticated
      new(401)
    end
  end
end
