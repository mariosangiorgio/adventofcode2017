function parse(line: string) : [string, string, string] {
    let tokens = line.split(" ");
    return [tokens[0], tokens[1], tokens[2]];
}
let input = ['set b 81',
'set c b',
'jnz a 2',
'jnz 1 5',
'mul b 100',
'sub b -100000',
'set c b',
'sub c -17000',
'set f 1',
'set d 2',
'set e 2',
'set g d',
'mul g e',
'sub g b',
'jnz g 2',
'set f 0',
'sub e -1',
'set g e',
'sub g b',
'jnz g -8',
'sub d -1',
'set g d',
'sub g b',
'jnz g -13',
'jnz f 2',
    'sub h -1',
    'set g b',
'sub g c',
'jnz g 2',
'jnz 1 3',
'sub b -17',
'jnz 1 -23'].map(parse)
function value(x: string, registers): number {
    let parsed = Number(x)
    if (!isNaN(parsed)) {
        return parsed
    }
    else {
        return registers[x]
    }
}
function interpret(instructions) {
    let program_counter = 0
    let n = instructions.length
    let registers = {
        'a': 0,
        'b':0,
        'c':0,
        'd':0,
        'e':0,
        'f':0,
        'g':0,
        'h':0
    }
    let mul_counter = 0    
    while (program_counter >= 0 && program_counter < n) {
        let i = instructions[program_counter]
        switch (i[0]) {
            case "set": {
                registers[i[1]] = value(i[2], registers)
                program_counter = program_counter +1
                break;
            }
            case "sub": {
                registers[i[1]] = registers[i[1]] - value(i[2], registers)
                program_counter = program_counter +1                
                break;
            }
            case "mul": {
                mul_counter = mul_counter + 1
                registers[i[1]] = registers[i[1]] * value(i[2], registers)
                program_counter = program_counter +1
                break;
            }            
            case "jnz": {
                if (value(i[1], registers) != 0) {
                    program_counter = program_counter + value(i[2], registers)
                }
                else {
                    program_counter = program_counter +1                    
                }
                break;
            }                        
        }
    }
    console.log(mul_counter)
}
interpret(input)