module Tattle
  class Error
    def initialize(line, column, message)
      @line, @column, @message = line, column, message
    end

    def to_s
      "#{self.class} at (line: #{@line}, column: #{@column}):\n\t#{@message}"
    end
  end
end
