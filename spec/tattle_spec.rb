require 'spec_helper'

module Tattle
  class Error
    attr_reader :message # for testing purposes
  end
end

def analyze_file(file)
  Tattle.errors.clear
  Tattle.analyze file
end

def errors_should_include_message(message)
  expect(Tattle.errors.clone.keep_if { |e| e.message.include? message }.empty?).to be false
end

describe Tattle do
  it 'has a version number' do
    expect(Tattle::VERSION).not_to be nil
  end

  context 'examples' do
    describe 'example 1' do
      before(:all) { analyze_file 'spec/examples/example1.rb' }

      it 'should find no errors' do
        expect(Tattle.errors.empty?).to be true
      end
    end

    describe 'example 2' do
      before(:all) { analyze_file 'spec/examples/example2.rb' }

      it 'should find one error' do
        expect(Tattle.errors.count).to eq 1
      end

      it 'should not be able to find symbol b' do
        errors_should_include_message "Could not find symbol: b"
      end
    end

    describe 'example 3' do
      before(:all) { analyze_file 'spec/examples/example3.rb' }

      it 'should find 3 errors' do
        skip 'Need to bring puts into scope'
        expect(Tattle.errors.count).to eq 3
      end

      it 'should not be able to find symbol b' do
        errors_should_include_message "Could not find symbol: b"
      end

      it 'should not be able to find symbol c' do
        errors_should_include_message "Could not find symbol: c"
      end

      it 'should not be able to find symbol d' do
        errors_should_include_message "Could not find symbol: d"
      end
    end
  end
end
