class EmptyStackError < StandardError; end

class Minilang
  attr_accessor :stack, :command

  def initialize(command)
    @stack = Stack.new
    @command = command.split
  end

  def eval
    command.each do |value|
      if value =~ /[\d]/
        stack.register = value.to_i
      else
        give_to_stack(value)
      end
    end
  end

  def give_to_stack(value)
    stack.send value.downcase.to_sym
  rescue NoMethodError
    puts "Invalid Token: #{value}"
  end
end

class Stack
  attr_accessor :stack, :register

  def initialize
    @stack = []
    @register = 0
  end

  def push
    stack << register
  end

  def add
    self.register += pop
  end

  def sub
    self.register -= pop
  end

  def mult
    self.register *= pop
  end

  def div
    self.register /= pop
  end

  def mod
    self.register %= pop
  end

  def pop
    raise EmptyStackError, "Empty Stack!" if stack.empty?
    self.register = stack.pop
  end

  def print
    puts register.nil? ? "Empty stack!" : register
  end
end

Minilang.new('PRINT').eval
# 0

Minilang.new('5 PUSH 3 MULT PRINT').eval
# 15

Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# 5
# 3
# 8

Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# 10
# 5

Minilang.new('5 PUSH POP POP PRINT').eval
# # Empty stack!

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# 6

Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# 12

Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# Invalid token: XSUB

Minilang.new('-3 PUSH 5 SUB PRINT').eval
# 8

Minilang.new('6 PUSH').eval
# (nothing printed; no PRINT commands)
