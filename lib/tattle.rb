require 'tattle/version'

require 'tattle/closure'
require 'tattle/parser'
require 'tattle/analyzer'

module Tattle
  def self.analyze(filename)
    errors.clear

    ast = to_ast(File.read(filename))
    Tattle::Analyzer.analyze ast, Tattle::Closure.compute(ast)

    if errors.any?
      # Print the errors
    else
      # Print success
    end
  end

  def self.errors
    @errors ||= []
  end

  private
  
  def self.to_ast(text)
    Tattle::Parser.parse text
  end
end
