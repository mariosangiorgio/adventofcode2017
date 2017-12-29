state=:a
position=0
tape=Hash.new(false)
for i in 1..12317297
  case state
    when :a
      unless tape[position] then
        tape[position]=true
        position=position+1
        state=:b
      else
        tape[position]=false
        position=position-1
        state=:d
      end
    when :b
      unless tape[position] then
        tape[position]=true
        position=position+1
        state=:c
      else
        tape[position]=false
        position=position+1
        state=:f
      end
    when :c
      unless tape[position] then
        tape[position]=true
        position=position-1
        state=:c
      else
        tape[position]=true
        position=position-1
        state=:a
      end
    when :d
      unless tape[position] then
        tape[position]=false
        position=position-1
        state=:e
      else
        tape[position]=true
        position=position+1
        state=:a
      end
    when :e
      unless tape[position] then
        tape[position]=true
        position=position-1
        state=:a
      else
        tape[position]=false
        position=position+1
        state=:b
      end
    when :f
      unless tape[position] then
        tape[position]=false
        position=position+1
        state=:c
      else
        tape[position]=false
        position=position+1
        state=:e
      end
  end
end
puts tape.count{|x| x[1]}
