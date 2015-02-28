module Tattle
  class Closure
    def self.compute(ast, current_closure)
      if ast.module?
        current_closure[ast.module_name] =
          Closure.compute(ast.module_body,
                          Closure.new({},
                                      current_closure))
      else
        current_closure
      end
    end

    def initialize(closure = {}, parent = nil)
      @closure, @parent = closure, parent
    end

    def add(symbol, value = true)
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

    def merge(closure_hash)
      @closure.merge! closure_hash
    end
  end
end
