require 'spec_helper'

# Expose the attributes so we can test them
module Tattle
  class Closure
    attr_reader :closure, :parent
  end
end

RSpec.describe Tattle::Closure do
  describe '#add' do
    before(:each) { @closure = Tattle::Closure.new({a: true}) }

    context 'when the symbol is in the closure' do
      it 'does not change the underlying hash' do
        hash = @closure.closure.clone
        @closure.add :a
        expect(@closure.closure).to eq hash
      end
    end

    context 'when the symbols is not in the closure' do
      it 'changes the underlying hash' do
        hash = @closure.closure.clone
        @closure.add :b
        expect(@closure.closure).to_not eq hash
      end
    end
  end

  describe '#include?' do
    let(:parent) { Tattle::Closure.new({a: true}) }
    let(:closure) { Tattle::Closure.new({b: true}, parent) }

    context 'when the symbol is in the closure' do
      it 'returns true' do
        expect(closure.include? :b).to be true
      end
    end

    context 'when the symbol is in not in the closure' do
      context 'when the closure has a parent that includes the symbol' do
        it 'returns true' do
          expect(closure.include? :a).to be true
        end
      end

      context 'when the closure has a parent that does not include the symbol' do
        it 'returns false' do
          expect(closure.include? :c).to be false
        end
      end

      context 'when the closure does not have a parent' do
        it 'returns false' do
          expect(parent.include? :c).to be false
        end
      end
    end
  end

  describe '#merge' do
    before(:each) { @closure = Tattle::Closure.new({a: true, b: true}) }

    context 'when no keys are shared between the hashes' do
      let(:new_hash) { {c: true, d: true} }

      it 'updates the underlying hash' do
        hash = @closure.closure.clone
        @closure.merge(new_hash)
        expect(@closure.closure).to_not eq hash
      end

      it 'adds all the symbols to the underlying hash' do
        @closure.merge(new_hash)
        new_hash.keys.each { |k| expect(@closure.closure.has_key?(k)).to be true }
      end
    end

    context 'when some of the keys are shared between the hashes' do
      let(:new_hash) { {a: false, c: true} }

      it 'adds the missing keys to the underlying hash' do
        @closure.merge(new_hash)
        expect(@closure.closure.has_key?(:c)).to be true
      end

      it 'does not overwrite the values of the common keys' do
        @closure.merge(new_hash)
        expect(@closure.closure[:a]).to be true
      end
    end
  end
end
