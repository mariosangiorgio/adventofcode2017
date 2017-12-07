class Entry
  def initialize(name : String, weight : Int32, children : Array(String))
    @name = name
    @weight = weight
    @children = children
  end

  def weight(data)
    @weight + @children.map{|child| data[child].weight(data).as(Int32)}.sum
  end

  def imbalance(data)
    values = Set.new @children.map{|child| data[child].weight(data).as(Int32)}
    if values.empty?
      0
    else
      values.max - values.min
    end
  end

end
nodes = Set(String).new
children = Set(String).new
data = {} of String => Entry
File.each_line "/Users/mariosangiorgio/Downloads/input" do |line|
  tokens = line.gsub(/[\(\)\->,]/, "").split(/\s+/)
  nodes << tokens[0]
  children.concat tokens.skip(2)
  data[tokens[0]] = Entry.new(tokens[0], tokens[1].to_i, tokens.skip(2))
end
root = nodes.subtract(children).first
puts root
data.each do |key, value|
  imbalance = value.imbalance(data)
  if imbalance != 0
    puts key
    puts imbalance
    puts data[key].@children.map{|child| {child, data[child].@weight, data[child].weight(data)}}
  end
end