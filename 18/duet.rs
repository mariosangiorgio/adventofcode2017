use std::collections::VecDeque;
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
  Rcv(Register),
  Set(Register, Operand),
  Add(Register, Operand),
  Mul(Register, Operand),
  Mod(Register, Operand),
  Jgz(Operand, Operand)
}

enum RunResult{
  Done,
  Send(Value),
  Blocked
}

struct Interpreter<'a>{
  program_counter : i64,
  registers : Vec<Value>,
  operations : &'a Vec<Operation>,
  input_channel : VecDeque<Value>,
  values_sent : u32
}

impl <'a> Interpreter<'a>{
  fn new(id : Value, operations : &'a Vec<Operation>) -> Interpreter<'a>{
    let mut registers : Vec<Value> = iter::repeat(0).take(26).collect();
    registers['p' as usize - 'a' as usize] = id;
    Interpreter{
      program_counter: 0,
      operations: operations,
      registers: registers,
      input_channel : VecDeque::new(),
      values_sent: 0
    }
  }

  fn enqueue(&mut self, value : Value) -> (){
    self.input_channel.push_back(value);
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

  fn interpret(&mut self) -> RunResult {
    loop{
      if self.program_counter < 0 || self.program_counter >= self.operations.len() as i64 {
        return RunResult::Done
      }
      let operation = &self.operations[self.program_counter as usize];
      self.program_counter = self.program_counter + 1;
      match operation{
        &Operation::Snd(x) =>{
          self.values_sent = self.values_sent + 1;
          return RunResult::Send(self.get_value(x))
        },
        &Operation::Rcv(x) => {
          // If the queue has the value, use it. Otherwise block and yield
          if let Some(value) = self.input_channel.pop_front(){
            self.set(x, Operand::Literal(value))
          }
          else{
            self.program_counter = self.program_counter - 1;
            return RunResult::Blocked
          }
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
          self.program_counter = self.program_counter - 1 + self.get_value(y);
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
    "rcv" => Operation::Rcv(parse_register(tokens.next().unwrap())),
    "jgz" => Operation::Jgz(parse_operand(tokens.next().unwrap()), parse_operand(tokens.next().unwrap())),
    _ => panic!()
  }

}

fn main() {
  let f = File::open("/Users/mariosangiorgio/Downloads/input").unwrap();
  let file = BufReader::new(&f);
  let operations = file.lines().map(|l|parse(l.unwrap())).collect();

  let mut interpreter0 = Interpreter::new(0, &operations);
  let mut can_run0 = true;
  let mut interpreter1 = Interpreter::new(1, &operations);
  let mut can_run1 = true;

  while can_run0 || can_run1 {
    match interpreter0.interpret(){
      RunResult::Send(v) =>{
        interpreter1.enqueue(v);
        can_run1 = true;
      },
      _ => can_run0 = false
    }
    match interpreter1.interpret(){
      RunResult::Send(v) =>{
        interpreter0.enqueue(v);
        can_run0 = true;
      },
      _ => can_run1 = false
    }
  }
  println!("{0}", interpreter1.values_sent)
}