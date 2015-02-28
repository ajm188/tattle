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

      node_types = closures + [:begin, :lvasgn, :ivasgn, :cvasgn]
      node_types.each do |sym|
        define_method "#{sym}?" do
          type == sym
        end
      end

      alias :local_var_assignment? :lvasgn?
      alias :instance_var_assignment? :ivasgn?
      alias :class_var_assignment? :cvasgn?

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
