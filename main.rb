require 'discordrb'
require 'mongo'

TRAILER_ROLE = ENV['TRAINER_ROLE']
ALLOWED_CHANNELS = Array(ENV['ALLOWED_CHANNELS']&.split(','))

bot = Discordrb::Bot.new(token: ENV['DISCORD_BOT_TOKEN'])
client = Mongo::Client.new(['db'])
words = client[:words]

bot.message(start_with: '!') do |event|
  break if ALLOWED_CHANNELS&.none? { |c| c == event.channel.id }

  case event.content
  when /\A!ask /i
    key = $'.downcase.strip
    type, key = key.split('_', 2) if key.match?(/\w+_\w+/)
    next event.respond('Invalid input.') if key.nil? || key.empty?

    records = words.find({ key: key }).to_a
    if (index_of_record = records.find_index { |r| r['type'] == type })
      record = records.slice!(index_of_record)
    end

    next event.respond('Record not found.') if record.nil? && records.count.zero?
    next event.respond(record['value']) if record && records.count.zero?

    if type
      if record
        event.respond(record['value'])
      else
        event.respond(
          <<~MESSAGE
            Record not found. Possible records are:
            ```
            #{records.map { |r| r['type'] ? "#{r['type']}_#{r['key']}" : r['key'] }.join("\n")}
            ```
          MESSAGE
        )
      end
    elsif record
      event.respond(
        <<~MESSAGE
          Note that there are other possible records:
          ```
          #{records.map { |r| r['type'] ? "#{r['type']}_#{r['key']}" : r['key'] }.join("\n")}
          ```
          #{record['value']}
        MESSAGE
      )
    elsif records.count == 1
      event.respond(records.first['value'])
    else
      event.respond(
        <<~MESSAGE
          More than one records found:
          ```
          #{records.map { |r| r['type'] ? "#{r['type']}_#{r['key']}" : r['key'] }.join("\n")}
          ```
        MESSAGE
      )
    end
  when /\A!learn /i
    key, value = $'.split(' ', 2)
    key = key.downcase.strip
    type, key = key.split('_', 2) if key.match?(/\w+_\w+/)
    next event.respond('Not authorized.') unless event.author.roles.any? { |r| r.name == TRAILER_ROLE }
    next event.respond('Invalid input.') if [key, value].any? { |x| x.nil? || x.empty? }

    words.replace_one({ key: key, type: type }, { key: key, type: type, value: value }, upsert: true)
    event.respond("Successfully learned `#{type ? "#{type}_#{key}" : key}`.") unless [key, value].any? { |x| x.nil? || x.empty? }
  when /\A!forget /i
    key = $'.downcase.strip
    type, key = key.split('_', 2) if key.match?(/\w+_\w+/)
    next event.respond('Not authorized.') unless event.author.roles.any? { |r| r.name == TRAILER_ROLE }
    next event.respond('Invalid input.') if key.nil? || key.empty?

    result = words.delete_one({ key: key, type: type })
    next event.respond('Record not found.') if result.deleted_count.zero?

    event.respond("Successfully forgot `#{type ? "#{type}_#{key}" : key}`.")
  else
    event.respond(
      <<~MESSAGE
        Command not found. Possible commands are:
        ```
        !ask [type_]key
        !learn [type_]key value
        !forget [type_]key
        ```
      MESSAGE
    )
  end
end

bot.run
