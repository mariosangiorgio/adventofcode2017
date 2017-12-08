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
    from_child = @children.map{|child| data[child].imbalance(data).as(Int32|Nil)}.find{|e|!e.nil?}
    if from_child.nil?
        values = @children.group_by{|child| data[child].weight(data).as(Int32)}
        if values.empty? || values.size == 1
          nil
        else
          puts values
          to_balance, item = values.find{|k,v| v.size == 1}.as(Tuple(Int32,Array(String)))
          to_match, _ = values.find{|k,v| v.size != 1}.as(Tuple(Int32,Array(String)))
          data[item.first].@weight + (to_match - to_balance)
        end
    else
      from_child
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
puts data[root].imbalance(data)