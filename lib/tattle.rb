require 'tattle/version'

require 'tattle/closure'
require 'tattle/parser'
require 'tattle/analyzer'

module Tattle
  def self.analyze(filename)
    ast = to_ast(File.read(filename))
    Tattle::Analyzer.analyze ast, Tattle::Closure.compute(ast)
  end

  def self.errors
    @errors ||= []
  end

  private
  
  def self.to_ast(text)
    Tattle::Parser.parse text
  end
end
