use std::io::BufRead;
use std::io::BufReader;
use std::iter;
use std::fs::File;

type Register = char;
type Value = i64;

#[derive(Clone, Copy)]
enum Operand{
  Register(Register),
  Literal(Value)
}

enum Operation{
  Snd(Operand),
  Set(Register, Operand),
  Add(Register, Operand),
  Mul(Register, Operand),
  Mod(Register, Operand),
  Rcv(Operand),
  Jgz(Operand, Operand)
}

struct Interpreter{
  registers : Vec<Value>,
  last_played : Option<Value>
}

impl Interpreter{
  fn new() -> Interpreter{
    Interpreter{
      registers: iter::repeat(0).take(26).collect(),
      last_played: None
    }
  }

  fn get_value(&self, value : Operand) -> Value {
    match value{
      Operand::Register(r) => self.get(r),
      Operand::Literal(v) => v
    }
  }

  fn get(&self, register : Register) -> Value {
    self.registers[(register as usize) - ('a' as usize)]
  }

  fn set(&mut self, register : Register, value : Operand) -> () {
    self.registers[(register as usize) - ('a' as usize)] = self.get_value(value);
  }

  fn interpret(&mut self, operations: &Vec<Operation>) -> Option<Value> {
    let mut program_counter = 0;
    loop{
      let operation = &operations[program_counter];
      program_counter = program_counter + 1;
      match operation{
        &Operation::Snd(value) => self.last_played = Some(self.get_value(value)),
        &Operation::Rcv(x) => if self.get_value(x) != 0 {
          return self.last_played
        },
        &Operation::Set(x,y) => self.set(x,y),
        &Operation::Add(x,y) =>
        {
          let v = Operand::Literal(self.get(x) + self.get_value(y));
          self.set(x, v)
        },
        &Operation::Mul(x,y) => {
          let v = Operand::Literal(self.get(x) * self.get_value(y));
          self.set(x, v)
        },
        &Operation::Mod(x,y) => {
          let v = Operand::Literal(self.get(x) % self.get_value(y));
          self.set(x, v)
        },
        &Operation::Jgz(x,y) => if self.get_value(x) > 0 {
          program_counter = (program_counter as i64 - 1 + self.get_value(y)) as usize;
        }
      }
    }
  }
}

fn parse(input : String) -> Operation{
  fn parse_register(register : &str) -> Register{
    register.chars().next().unwrap()
  }
  fn parse_operand(operand : &str) -> Operand{
    let first_char = operand.chars().next().unwrap();
    if first_char >= 'a' && first_char <= 'z'
    {
          Operand::Register(first_char)
    }
    else{
          Operand::Literal(operand.parse::<>().unwrap())
    }
  }
  let mut tokens = input.split_whitespace();
  match tokens.next().unwrap(){
    "snd" => Operation::Snd(parse_operand(tokens.next().unwrap())),
    "set" => Operation::Set(parse_register(tokens.next().unwrap()), parse_operand(tokens.next().unwrap())),
    "add" => Operation::Add(parse_register(tokens.next().unwrap()), parse_operand(tokens.next().unwrap())),
    "mul" => Operation::Mul(parse_register(tokens.next().unwrap()), parse_operand(tokens.next().unwrap())),
    "mod" => Operation::Mod(parse_register(tokens.next().unwrap()), parse_operand(tokens.next().unwrap())),
    "rcv" => Operation::Rcv(parse_operand(tokens.next().unwrap())),
    "jgz" => Operation::Jgz(parse_operand(tokens.next().unwrap()), parse_operand(tokens.next().unwrap())),
    _ => panic!()
  }

}

fn main() {
  let f = File::open("/Users/mariosangiorgio/Downloads/input").unwrap();
  let file = BufReader::new(&f);
  let mut interpreter = Interpreter::new();
  let operations = file.lines().map(|l|parse(l.unwrap())).collect();
  println!("{:?}", interpreter.interpret(&operations));
}