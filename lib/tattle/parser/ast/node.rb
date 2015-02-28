require 'parser'

module Parser
  module AST
    class Node
      def module?
        type == :module
      end
    end
  end
end
