require 'parser'

module Parser
  module AST
    class Node
      closures = [:module, :class, :defs, :def, :block]
      closures.each do |sym|
        define_method "#{sym}_body" do
          children.last
        end
      end

      node_types = closures +
        [:begin, :lvasgn, :ivasgn, :cvasgn, :send] + # programming constructs
        [:nil, :int, :float, :sym, :true, :false, :str] + # simple literals
        [:ivar, :cvar] + # things that aren't really literals, but act enough like them in ruby
        [:dstr, :array, :hash] # complex literals (can't determine if literal without checking contents against the closure)
      node_types.each do |sym|
        define_method "#{sym}?" do
          type == sym
        end
      end

      alias :local_var_assignment? :lvasgn?
      alias :instance_var_assignment? :ivasgn?
      alias :class_var_assignment? :cvasgn?

      alias :instance_variable? :ivar?
      alias :class_variable? :cvar?

      alias :interpolated_str? :dstr?

      def literal?
        nil? || int? || float? || sym? || true? || false? || str? ||
          instance_variable? || class_variable?
      end

      def array_elements
        children
      end

      def hash_pairs
        children
      end

      def send_receiver
        children.first
      end

      def send_message
        children[1]
      end

      def send_args
        children[2..-1]
      end

      def module_name
        children.first.children.last
      end

      def class_name
        children.first.children.last
      end

      def defs_name
        children[1]
      end

      def defs_args
        arg_array children[2].children
      end

      def def_name
        children.first
      end

      def def_args
        arg_array children[1].children
      end

      def method_args
        defs? ? defs_args : def_args
      end

      # Return the method the block was passed to
      def block_method
        children.first
      end

      def block_args
        arg_array children[1].children
      end

      def assignment_left_side
        children.first
      end

      def assignment_right_side
        children.last
      end

      private

      def arg_array(args_list)
        args_list.map { |arg_node| arg_node.children.first }
      end
    end
  end
end
