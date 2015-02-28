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

  describe '#block?' do
    context 'when the AST node is a block' do
      let(:block1) { Tattle::Parser.parse('a.each { |e| e }') }
      let(:block2) { Tattle::Parser.parse('->(e) { e }') }

      it 'returns true' do
        expect(block1.block?).to be true
        expect(block2.block?).to be true
      end
    end

    context 'when the AST node is not a block' do
      it 'returns false' do
        expect(Tattle::Parser.parse('2 + 2').block?).to be false
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

  describe '#lvasgn?, #local_var_assignment?' do
    let(:lvasgn_node) { Tattle::Parser.parse('a = b') }
    let(:other_node) { Tattle::Parser.parse('@a = 5') }

    context 'when the AST node is a local assignment' do
      it 'returns true' do
        expect(lvasgn_node.lvasgn?).to be true
        expect(lvasgn_node.local_var_assignment?).to be true
      end
    end

    context 'when the AST node is not a local assignment' do
      it 'should return false' do
        expect(other_node.lvasgn?).to be false
        expect(other_node.local_var_assignment?).to be false
      end
    end
  end

  describe '#ivasgn?, #instance_var_assignment?' do
    let(:ivasgn_node) { Tattle::Parser.parse('@a = 5') }
    let(:other_node) { Tattle::Parser.parse('@@a = 6') }

    context 'when the AST node is an instance variable assignment' do
      it 'returns true' do
        expect(ivasgn_node.ivasgn?).to be true
        expect(ivasgn_node.instance_var_assignment?).to be true
      end
    end

    context 'when the AST node is not an instance variable assignment' do
      it 'returns false' do
        expect(other_node.ivasgn?).to be false
        expect(other_node.instance_var_assignment?).to be false
      end
    end
  end

  describe '#cvasgn?, #class_instance_var_assignment?' do
    let(:cvasgn_node) { Tattle::Parser.parse('@@a = 6') }
    let(:other_node) { Tattle::Parser.parse('a = b') }

    context 'when the AST node is a class variable assignment' do
      it 'returns true' do
        expect(cvasgn_node.cvasgn?).to be true
        expect(cvasgn_node.class_var_assignment?).to be true
      end
    end

    context 'when the AST node is not a class variable assignment' do
      it 'returns false' do
        expect(other_node.cvasgn?).to be false
        expect(other_node.class_var_assignment?).to be false
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

  describe '#block_method' do
    let(:block) { Tattle::Parser.parse('a.each { |e| e }') }
    let(:method) { Tattle::Parser.parse('a.each') }

    it 'returns the method the block is being passed to' do
      expect(block.block_method).to eq method
    end
  end

  describe '#block_args' do
    let(:block) { Tattle::Parser.parse('a.each { |e| e }') }

    it 'returns the variables the block expects' do
      expect(block.block_args).to eq [:e]
    end
  end

  describe '#assignment_left_side' do
    let(:assignment1) { Tattle::Parser.parse('a = b') }
    let(:assignment2) { Tattle::Parser.parse('@a = b') }

    it 'returns the left hand of the assignment as a symbol' do
      expect(assignment1.assignment_left_side).to eq :a
      expect(assignment2.assignment_left_side).to eq :@a
    end
  end

  describe '#assignment_right_side' do
    let(:assignment) { Tattle::Parser.parse('a = 5') }
    let(:five) { Tattle::Parser.parse('5') }

    it 'returns the right hand side of an assignment' do
      expect(assignment.assignment_right_side).to eq five
    end
  end
end
