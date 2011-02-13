# encoding: utf-8
# shell.rb
#                           wookay.noh at gmail.com

require 'readline'
require 'rubygems'
require 'irb/completion'
require 'pp'
include Readline

HISTORY_PATH = "#{ENV['HOME']}/.console_history"
LF = "\n"

COMMANDS = %w{help open history clear quit}

def force_encoding_utf8 str
  if str.respond_to? :force_encoding
    str.force_encoding("UTF-8")
  else
    str
  end
end

class Shell
  attr_accessor :options
  def initialize options
    begin
      @HISTORY = open(HISTORY_PATH).read.lines.to_a
    rescue
      @HISTORY = []
    end
    @history_file = open(HISTORY_PATH,'a')
    @options = options
    @HISTORY.each do |action|
      HISTORY.push action
    end
    Readline.completion_proc = proc do |input|
      self.completion_list.sort.uniq.select do |history| 
          history.size != input.size and 0 == force_encoding_utf8(history).index(input)
      end
    end
  end
  def completion_list
    methods = @delegate.call({}, 'completion')
    (methods or '').split(LF).map {|x| x } + COMMANDS + @HISTORY
  end
  def delegate &block
    @delegate = block
  end
  def history_push input
    if input.strip.size > 0
      HISTORY.push input
      @HISTORY.push input
      @history_file.write "#{input}\n"
    end
  end
  def start
    at_exit do
      puts "exit"
    end
    while input = readline(@options[:prompt], true)
      case input.strip
      when 'clear'
        @HISTORY = []
        @history_file.close
        open(HISTORY_PATH,'w') do |f|
          f.write("")
        end
        @history_file = open(HISTORY_PATH,'a')
      when 'history'
        idx = @HISTORY.size
        ary = @HISTORY.map do |obj|
          s = "%3d  %s" % [idx, obj]
          idx -= 1
          s
        end
        puts ary
      when /^\!/
        n = input.gsub(/^\!/,'').strip.to_i
        input = @HISTORY[-n].strip
        puts input
        history_push input
        @delegate.call @options.merge(:print=>true), input
      when 'q', 'quit'
        break
      else
        history_push input
        @delegate.call @options.merge(:print=>true), input
      end
    end
  end
end
