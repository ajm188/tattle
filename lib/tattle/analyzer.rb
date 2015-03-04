require 'tattle/error'

module Tattle
  class Analyzer
    def self.analyze(ast, closure)
      if ast.module?
        analyze(ast.module_body, closure.lookup(ast.module_name))
      elsif ast.class?
        analyze(ast.class_body, closure.lookup(ast.class_name))
      elsif ast.defs?
        analyze(ast.defs_body, Tattle::Closure.new(bind_args(ast.defs_args), closure))
      elsif ast.def?
        analyze(ast.def_body, Tattle::Closure.new(bind_args(ast.def_args), closure))
      elsif ast.block?
        analyze(ast.block_body, Tattle::Closure.new(bind_args(ast.block_args), closure))
      elsif ast.begin?
        ast.children.each { |child| analyze(child, closure) }
      elsif ast.if?
        ([ast.if_condition] + ast.if_branches).each { |if_node| analyze(if_node, closure) }
      elsif ast.while?
        [ast.while_condition, ast.while_body].each { |node| analyze(node, closure) }
      elsif ast.send?
        analyze_send(ast, closure)
      elsif ast.local_var_assignment?
        closure.add(ast.assignment_left_side)
        analyze(ast.assignment_right_side, closure)
      elsif ast.instance_var_assignment?
        analyze(ast.assignment_right_side, closure)
      elsif ast.class_var_assignment?
        analyze(ast.assignment_right_side, closure)
      elsif ast.literal?
        return
      elsif ast.array?
        ast.array_elements.each { |e| analyze(e, closure) }
      elsif ast.hash?
        ast.hash_pairs.each do |pair|
          pair.each { |e| analyze(e, closure) }
        end
      end
    end

    private

    def self.analyze_send(ast, closure)
      if ast.send_receiver
        analyze(ast.send_receiver, closure)
        send_closure = closure.lookup(ast.send_receiver)
        unless send_closure
          Tattle.errors << Tattle::Error.new(ast.loc.line,
                                             ast.loc.column,
                                             "Could not find symbol: #{ast.send_receiver}")
          send_closure = closure
        end
      else
        send_closure = closure
      end

      # Check the message and arity
      method_ast = send_closure.lookup(ast.send_message)
      if method_ast
        method_arity, param_length = method_ast.method_args.count, ast.send_args.count
        Tattle.errors << Tattle::Error.new(ast.loc.line,
                                           ast.loc.column,
                                           "Wrong number of arguments given: (#{param_length} for #{method_arity})") unless method_arity == param_length

        ast.send_args.each { |arg_node| analyze(arg_node, closure) }
      else
        Tattle.errors << Tattle::Error.new(ast.loc.line,
                                           ast.loc.column,
                                           "Could not find symbol: #{ast.send_message}")
      end
    end

    def self.bind_args(args)
      args.reduce({}) { |h, arg| h.merge({arg => true}) }
    end
  end
end
