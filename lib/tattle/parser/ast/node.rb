require 'parser'

module Parser
  module AST
    class Node
      closures = [:module, :class, :defs, :def]
      closures.each do |sym|
        define_method "#{sym}_body" do
          children.last
        end
      end

      node_types = closures + [:begin]
      node_types.each do |sym|
        define_method "#{sym}?" do
          type == sym
        end
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

      private

      def arg_array(args_list)
        args_list.map { |arg_node| arg_node.children.first }
      end
    end
  end
end
