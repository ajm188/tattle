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

  describe '#class?' do
    context 'when the AST node is a class definition' do
      it 'returns true' do
        expect(Tattle::Parser.parse('class MyClass; end').class?).to be true
      end
    end

    context 'when the AST node is not a class definition' do
      it 'returns false' do
        expect(Tattle::Parser.parse('module MyModule; end').class?).to be false
        expect(Tattle::Parser.parse('a = b').class?).to be false
      end
    end
  end

  describe '#defs?' do
    context 'when the AST node is a self. method definition' do
      it 'returns true' do
        expect(Tattle::Parser.parse('def self.foo; end').defs?).to be true
      end
    end

    context 'when the AST node is not a self. method definition' do
      it 'returns false' do
        expect(Tattle::Parser.parse('def foo; end').defs?).to be false
      end
    end
  end

  describe '#def?' do
    context 'when the AST node is a method definition' do
      it 'returns true' do
        expect(Tattle::Parser.parse('def foo; end').def?).to be true
      end
    end
    
    context 'when the AST node is not a method definition' do
      it 'returns false' do
        expect(Tattle::Parser.parse('def self.foo; end').def?).to be false
      end
    end
  end

  describe '#begin?' do
    let(:begin_node) { Tattle::Parser.parse('def foo; end; def bar; end') }
    let(:class_node) { Tattle::Parser.parse('class MyClass; end') }

    context 'when the AST node has type :begin' do
      it 'returns true' do
        expect(begin_node.begin?).to be true
      end
    end

    context 'when the AST node is not type :begin' do
      it 'returns false' do
        expect(class_node.begin?).to be false
      end
    end
  end

  describe '#module_body' do
    let(:module_node) { Tattle::Parser.parse('module MyModule; def foo; end; end') }
    let(:module_body) { Tattle::Parser.parse('def foo; end') }

    it 'returns the body of the module' do
      expect(module_node.module_body).to eq module_body
    end
  end

  describe '*_body methods' do
    subject { ::Parser::AST::Node.new(:node) }

    # All of these have the same implementation as #module_body,
    # so we just need to ensure that they are defined
    [:module, :class, :defs, :def].each do |sym|
      it { should respond_to("#{sym}_body".to_sym) }
    end
  end

  describe '#module_name' do
    let(:module_node) { Tattle::Parser.parse('module MyModule; end') }

    it 'returns the name of the module' do
      expect(module_node.module_name).to eq :MyModule
    end
  end

  describe '#class_name' do
    let(:class_node) { Tattle::Parser.parse('class MyClass; end') }

    it 'returns the name of the class' do
      expect(class_node.class_name).to eq :MyClass
    end
  end

  describe '#defs_name' do
    let(:defs_node) { Tattle::Parser.parse('def self.foo; end') }

    it 'returns the name of the method' do
      expect(defs_node.defs_name).to eq :foo
    end
  end

  describe '#def_name' do
    let(:def_node) { Tattle::Parser.parse('def foo; end') }

    it 'returns the name of the method' do
      expect(def_node.def_name).to eq :foo
    end
  end

  describe '#defs_args' do
    let(:defs_node) { Tattle::Parser.parse('def self.foo(a,b); end') }

    it 'returns a list of argument symbols' do
      expect(defs_node.defs_args).to eq [:a, :b]
    end
  end

  describe '#def_args' do
    let(:def_node) { Tattle::Parser.parse('def foo(a,b); end') }

    it 'returns a list of argument symbols' do
      expect(def_node.def_args).to eq [:a, :b]
    end
  end
end
