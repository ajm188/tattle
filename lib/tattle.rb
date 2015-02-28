require 'tattle/version'

require 'tattle/closure'
require 'tattle/parser'
require 'tattle/error'

module Tattle
  def self.analyze(filename)
    file_text = File.read(filename)
    global_closure = Tattle::Closure.compute to_ast(file_text)
  end

  private
  
  def self.to_ast(text)
    Tattle::Parser.parse file_text
  end
end
