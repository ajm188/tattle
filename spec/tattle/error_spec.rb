require 'spec_helper'

RSpec.describe Tattle::Error do
  subject { Tattle::Error.new 0, 0, 'foo' }

  describe '#to_s' do
    it 'should return a string containing the line, column and message' do
      expect(subject.to_s).to eq "Tattle::Error at (line: 0, column: 0):\n\tfoo"
    end
  end
end
