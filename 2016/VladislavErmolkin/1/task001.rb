NUM_REGEX = %r{[-+]?[0-9]*\.?[0-9]+(?:[eE][-+]?[0-9]+)*}
SIGN_REGEX = %{[\+\-\*\/\!]{1}}

def main
  stack = validate_str gets
  result = R_P_N(stack)
  result.to_i if result == result.to_i
  return "=> " + result.to_s
rescue IOError => ex
  puts "#{ex.class}: #{ex.message}"
  exit
rescue TypeError
  puts "Error: Incorrect RPN."
  exit
rescue NoMethodError
  puts "Error: Incorrect RPN."
  exit
end

def validate_str(str)
  elements = str.split
  elements.map! do |element|
    if element.match(NUM_REGEX)
      element.to_f
    elsif element.match(SIGN_REGEX)
      element
    else
      raise IOError, "Input error."
    end
  end.reverse!
  elements
end

def R_P_N(source)
  stack = []
  until source.empty?
    if (el = source.pop).is_a? Float
      stack.push el
    else
      op1 = stack.pop
      op2 = stack.pop
      case el
      when "+"
        stack.push op1 + op2
      when "-"
        stack.push op2 - op1
      when "*"
        stack.push op1 * op2
      when "/"
        stack.push op2 / op1
      when "!"
        stack.push zeroing(op2, op1)
      end
    end
  end
  raise TypeError if stack.length != 1
  stack[0]
end

def zeroing(number, q)
  s = [number].pack("f").unpack("b*")[0]
  q.to_i.times { s.sub!("1", "0") }
  [s].pack("b*").unpack("f")[0]
end

puts main
