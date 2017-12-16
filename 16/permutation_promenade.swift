func shift(values : inout Array<Int>, n : Int) -> (){
  let c = values.count
  for i in 0..<c{
    values[i] = (values[i] + n)%c
    if(values[i] < 0){
      values[i] += c
    }
  }
}

func swapByValue(values : inout Array<Int>, a : Int, b : Int) -> (){
  swap(&values[a], &values[b])
}

func swapByPosition(values : inout Array<Int>, i : Int, j : Int) -> (){
  swap(&values[values.index(of:i)!], &values[values.index(of:j)!])
}

func reconstruct(values : Array<Int>) -> String{
  var s = ""
  for c in (0..<values.count).map({values.index(of:$0)!}){
    s.append(Character(UnicodeScalar(c + 97)!))
  }
  return s
}

import Foundation

do {
    var values = Array(0...15)
    var data = try NSString(contentsOfFile:  "/Users/mariosangiorgio/Downloads/input",
    encoding: String.Encoding.ascii.rawValue)
    let instructions =
          (data as String)
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: ",")
    for instruction in instructions{
      let from = instruction.index(instruction.startIndex, offsetBy: 0)
      let to = instruction.index(instruction.startIndex, offsetBy: 1)
      switch instruction[from..<to] {
      case "s":
        shift(values: &values, n: Int(instruction.substring(from: to))!)
      case "x":
        let items =
          instruction
            .substring(from: to)
            .components(separatedBy: "/")
            .map{Int($0)}
        swapByPosition(values: &values, i: items[0]!, j: items[1]!)
      case "p":
        let items =
          instruction
            .substring(from: to)
            .components(separatedBy: "/")
            .map{Int($0.unicodeScalars.first!.value - 97)}
        swapByValue(values: &values, a: items[0], b: items[1])
      default:
        fatalError()
      }
    }
    print(reconstruct(values: values))
}