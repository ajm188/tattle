module Tattle
  class Closure
    def self.compute(ast, current_closure = Closure.new)
      if ast.module?
        current_closure.add(ast.module_name,
                            Closure.compute(ast.module_body,
                                            Closure.new({},
                                                        current_closure))
                                   .merge(current_closure.closure_hash[ast.module_name] || {}))
      elsif ast.class?
        current_closure.add(ast.class_name,
                            Closure.compute(ast.class_body,
                                            Closure.new({},
                                                        current_closure))
                                   .merge(current_closure.closure_hash[ast.class_name] || {}))
      elsif ast.defs?
        current_closure.add(ast.defs_name,
                            Closure.compute(ast.defs_body,
                                            Closure.new(bind_args(ast.defs_args,
                                                                  current_closure),
                                                        current_closure)))
      elsif ast.def?
        current_closure.add(ast.def_name,
                            Closure.compute(ast.def_body,
                                            Closure.new(bind_args(ast.def_args,
                                                                  current_closure),
                                                        current_closure)))
      elsif ast.block?
        current_closure.add(ast,
                            Closure.compute(ast.block_body,
                                            Closure.new(bind_args(ast.block_args,
                                                                  current_closure),
                                                        current_closure)))
      elsif ast.begin?
        ast.children.each { |child| current_closure.merge Closure.compute(child, current_closure) }
      end 
      current_closure
    end

    attr_reader :parent

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

    def merge(closure_obj)
      case closure_obj
      when Closure
        @closure.merge! closure_obj.closure_hash
      when Hash
        @closure.merge! closure_obj
      end
    end

    protected

    def closure_hash
      @closure
    end

    private

    def self.bind_args(args, current_closure)
      args.reduce({}) { |h, arg| h.merge({arg => true}) }.merge({self: current_closure})
    end
  end
end
