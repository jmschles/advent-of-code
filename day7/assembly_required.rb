class Wire
  attr_reader :name
  attr_accessor :input_val

  def initialize(name: nil, input_val: nil)
    @name = name
    @input_val = input_val
  end
end

class CircuitPart
  attr_reader :circuit, :output, :inputs, :operator, :shift_amount

  def initialize(instructions, circuit)
    @circuit = circuit
    parse_instructions(instructions)
  end

  def parse_instructions(line)
    split_line = line.chomp.split
    @output, input_phrase = wire_or_input(split_line.last), split_line[0..-3]
    if input_phrase.length == 1
      @inputs = [wire_or_input(input_phrase.first)]
    elsif input_phrase.first == 'NOT'
      @inputs = [wire_or_input(input_phrase.last)]
      @operator = 'NOT'
    elsif input_phrase.length == 3 && input_phrase[1].include?('SHIFT')
      @inputs = [wire_or_input(input_phrase.first)]
      @operator = input_phrase[1]
      @shift_amount = input_phrase.last.to_i
    else
      @inputs = [wire_or_input(input_phrase.first), wire_or_input(input_phrase.last)]
      @operator = input_phrase[1]
    end
  end

  def wire_or_input(str)
    str.match(/\d+/) ? Wire.new(input_val: str.to_i) : find_or_create_wire(str)
  end

  def find_or_create_wire(name)
    wire_idx = circuit.wires.map(&:name).index(name)
    if wire_idx
      circuit.wires[wire_idx]
    else
      new_wire = Wire.new(name: name)
      circuit.wires << new_wire
      new_wire
    end
  end

  def resolve_output(override: false, override_val: nil)
    if override && @output.name == 'b'
      @output.input_val = override_val
      return
    end
    return unless inputs.all? { |i| !i.input_val.nil? }
    @output.input_val = @operator ? perform_operation : inputs.first.input_val
  end

  def perform_operation
    case @operator
    when 'OR'
      inputs[0].input_val | inputs[1].input_val
    when 'AND'
      inputs[0].input_val & inputs[1].input_val
    when 'NOT'
      ~inputs[0].input_val
    when 'LSHIFT'
      inputs[0].input_val << shift_amount
    when 'RSHIFT'
      inputs[0].input_val >> shift_amount
    end
  end
end

class Circuit
  attr_accessor :wires, :parts

  def initialize
    @wires = []
    @parts = []
  end

  def resolve(override: false, override_val: nil)
    until wires.all? { |w| !w.input_val.nil? }
      parts.each { |part| part.resolve_output(override: override, override_val: override_val) }
    end
  end
end

circuit = Circuit.new

File.open('input.txt').each_line do |line|
  next if line.empty?
  circuit.parts << CircuitPart.new(line, circuit)
end

circuit.resolve

a_input = circuit.wires.select { |w| w.name == 'a' }.first.input_val

circuit.wires.each { |w| w.input_val = nil }

circuit.resolve(override: true, override_val: a_input)

puts circuit.wires.select { |w| w.name == 'a' }.first.input_val
