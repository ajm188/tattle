require 'spec_helper'

RSpec.describe Tattle::Parser do
  describe '::parse' do
    it 'should return an AST node' do
      expect(Tattle::Parser.parse('2 + 2').class). to eq ::Parser::AST::Node
    end
  end
end
