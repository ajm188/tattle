require 'spec_helper'

module Tattle
  class Error
    attr_reader :message # for testing purposes
  end
end

describe Tattle do
  it 'has a version number' do
    expect(Tattle::VERSION).not_to be nil
  end

  context 'examples' do
    before(:each) { Tattle.errors.clear }

    describe 'example 1' do
      it 'should find no errors' do
        Tattle.analyze 'spec/examples/example1.rb'
        expect(Tattle.errors.empty?).to be true
      end
    end

    describe 'example 2' do
      before(:each) { Tattle.analyze 'spec/examples/example2.rb' }

      it 'should find one error' do
        expect(Tattle.errors.count).to eq 1
      end

      it 'should not be able to find symbol b' do
        expect(Tattle.errors.keep_if { |e| e.message.include? "Could not find symbol: b" }.empty?).to be false
      end
    end
  end
end
