# frozen_string_literal: true

module UwoBotLambda
  module ViewModels
    class PriceTag
      def initialize(price_tag_entity)
        @name = price_tag_entity.name
        @type = price_tag_entity.type
        @prices = price_tag_entity.prices
      end

      def typed?
        !@type.nil?
      end

      def display_name
        typed? ? "#{@type}_#{@name}" : @name
      end

      def price_table(**titles)
        titles = {
          registered_at: titles[:registered_at],
          price_value: titles[:price_value],
        }

        rows = @prices.map do |price|
          {
            registered_at: formatted_time_string(price.registered_at),
            price_value: price.value,
          }
        end

        formatted_table(titles, rows)
      end

      private

      def formatted_time_string(time)
        timezone = TZInfo::Timezone.get(UwoBotLambda.config.timezone)
        timezone.to_local(time).strftime('%F %R %z')
      end

      def formatted_table(titles, rows)
        all_rows = [titles] + rows
        all_rows.each { |r| r.transform_values! { |v| Text.new(v) } }
        widths = titles.keys.map do |k|
          [k, all_rows.map { |r| r[k].normalized_width }.max]
        end.to_h

        line = "+#{widths.values.map { |w| '-' * (w + 2) }.join('+')}+"
        renderer = lambda do |r|
          cells = r.map do |k, v|
            method = k == :price_value ? :rjust : :ljust
            v.public_send(method, widths[k])
          end

          "| #{cells.join(' | ')} |"
        end

        <<~PRICE_TABLE
          ```
          #{line}
          #{renderer.call(titles)}
          #{line}
          #{rows.map { |r| renderer.call(r) }.join("\n")}
          #{line}
          ```
        PRICE_TABLE
      end

      class Text
        FULL_SIZE_WHITESPACE = '　'

        def initialize(str)
          @raw = str.to_s.dup
        end

        def width
          @width ||=
            @raw.each_char.sum { |c| full_size?(c) ? Rational(5, 3) : 1 }
        end

        def normalized?
          width.to_i == width
        end

        def normalized_width
          return width if normalized?

          width + Rational(5, 3) * ((width * 3) % 3)
        end

        def to_s
          @raw
        end

        def ljust(width)
          return Text.new(@raw) if normalized_width > width

          count_full = (self.width * 3) % 3
          count_half = width - normalized_width

          Text.new(@raw + FULL_SIZE_WHITESPACE * count_full + ' ' * count_half)
        end

        def rjust(width)
          return Text.new(@raw) if normalized_width > width

          count_full = (self.width * 3) % 3
          count_half = width - normalized_width

          Text.new(' ' * count_half + FULL_SIZE_WHITESPACE * count_full + @raw)
        end

        private

        def full_size?(char)
          char.bytesize > 2
        end
      end
    end
  end
end
