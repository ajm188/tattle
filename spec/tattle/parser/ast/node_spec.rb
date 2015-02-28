require 'spec_helper'

RSpec.describe ::Parser::AST::Node do
  describe '#module?' do
    context 'when the AST node is a module definition' do
      it 'returns true' do
        expect(Tattle::Parser.parse('module MyModule; end').module?).to be true
      end
    end

    context 'when the AST node is not a module definition' do
      it 'returns false' do
        expect(Tattle::Parser.parse('class MyClass; end').module?).to be false
        expect(Tattle::Parser.parse('2 + 2').module?).to be false
      end
    end
  end
end
