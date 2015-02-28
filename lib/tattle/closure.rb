module Tattle
  class Closure
    def initialize(closure = {}, parent = nil)
      @closure, @parent = closure, parent
    end

    def add(symbol, value = true)
      return if @closure.has_key? symbol
      @closure[symbol] = value
    end

    def include?(symbol)
      if @closure.has_key? symbol
        true
      elsif @parent
        @parent.include? symbol
      else
        false
      end
    end
  end
end
