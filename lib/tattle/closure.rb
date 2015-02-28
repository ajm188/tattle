module Tattle
  class Closure
    def self.compute(ast, current_closure)
      if ast.module?
        current_closure.add(ast.module_name,
                            Closure.compute(ast.module_body,
                                            Closure.new({},
                                                        current_closure)))
      elsif ast.class?
        current_closure.add(ast.class_name,
                            Closure.compute(ast.class_body,
                                            Closure.new({},
                                                        current_closure)))
      elsif ast.method_def?
        current_closure.add(ast.method_name,
                            Closure.compute(ast.method_body,
                                            Closure.new({},
                                            current_closure)))
      elsif ast.block? # ast.proc? ast.lambda?
        # ???
      elsif ast.local_assignment?
        current_closure.add(ast.assignment_left_side)
      elsif ast.instance_var_assignment?
        current_closure.parent.add(ast.assignment_left_side)
      elsif ast.class_var_assignment?
        current_closure.parent.parent.add(ast.assignment_left_hand_side)
      end 
      current_closure
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
