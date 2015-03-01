require 'spec_helper'

RSpec.describe Tattle::Closure do
  describe '#add' do
    before(:each) { @closure = Tattle::Closure.new({a: true, c: false}) }

    context 'when the symbol is in the closure' do
      context 'and the value is the same' do
        it 'does not change the underlying hash' do
          hash = @closure.closure.clone
          @closure.add :a, true
          expect(@closure.closure).to eq hash
        end
      end

      context 'and the value is not the same' do
        it 'changes the underlying hash' do
          hash = @closure.closure.clone
          @closure.add :c, true
          expect(@closure.closure).to_not eq hash
        end
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

  describe '#lookup' do
    let(:parent) { Tattle::Closure.new({a: "foo"}) }
    let(:closure) { Tattle::Closure.new({b: 5}, parent) }

    context 'when the symbol is in the closure' do
      it 'returns the value the symbol maps to' do
        expect(closure.lookup :b).to eq 5
      end
    end

    context 'when the symbol is not in the closure' do
      context 'when the closure has a parent that includes the symbol' do
        it 'returns the value the symbol maps to' do
          expect(closure.lookup :a).to eq "foo"
        end
      end

      context 'when the closure has a parent, but the symbol is not included' do
        it 'returns nil' do
          expect(closure.lookup :c).to be nil
        end
      end

      context 'when the closure does not have a parent' do
        it 'returns nil' do
          expect(parent.lookup :c).to be nil
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

      it 'does overwrites the values of the common keys' do
        @closure.merge(new_hash)
        expect(@closure.closure[:a]).to be false
      end
    end
  end
end
