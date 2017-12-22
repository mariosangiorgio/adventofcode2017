package main

import (
	"fmt"
	"io/ioutil"
)

type coordinates struct {
	column int
	row    int
}

const (
	clean    = 0
	weakened = 1
	infected = 2
	flagged  = 3
)

func main() {
	data, err := ioutil.ReadFile("/Users/mariosangiorgio/Downloads/input")
	if err != nil {
		panic(err)
	}
	column := 1
	row := 1
	m := make(map[coordinates]int)
	for _, char := range string(data) {
		if char == '\n' {
			column = 1
			row = row + 1
		} else {
			if char == '#' {
				m[coordinates{column, row}] = infected
			} else {
				m[coordinates{column, row}] = clean
			}

			column = column + 1
		}
	}
	// Assumes square input
	current := coordinates{row / 2, row / 2}
	direction := coordinates{0, -1}
	infectedCount := 0
	for i := 1; i <= 10000000; i++ {
		switch m[coordinates{current.column, current.row}] {
		case clean:
			m[coordinates{current.column, current.row}] = weakened
			// turn left
			switch direction {
			case coordinates{0, -1}:
				direction = coordinates{-1, 0}
			case coordinates{0, 1}:
				direction = coordinates{1, 0}
			case coordinates{1, 0}:
				direction = coordinates{0, -1}
			case coordinates{-1, 0}:
				direction = coordinates{0, 1}
			default:
				panic("Invalid direction")
			}
		case weakened:
			infectedCount = infectedCount + 1
			m[coordinates{current.column, current.row}] = infected
		case infected:
			m[coordinates{current.column, current.row}] = flagged
			// turn right
			switch direction {
			case coordinates{0, -1}:
				direction = coordinates{1, 0}
			case coordinates{0, 1}:
				direction = coordinates{-1, 0}
			case coordinates{1, 0}:
				direction = coordinates{0, 1}
			case coordinates{-1, 0}:
				direction = coordinates{0, -1}
			default:
				panic("Invalid direction")
			}
		case flagged:
			m[coordinates{current.column, current.row}] = clean
			direction.column = -direction.column
			direction.row = -direction.row
		default:
			fmt.Println(clean)
			fmt.Println(weakened)
			fmt.Println(infected)
			fmt.Println(flagged)
			fmt.Println(m[coordinates{current.column, current.row}])
			panic("Invalid state")
		}
		current.column = current.column + direction.column
		current.row = current.row + direction.row
	}
	fmt.Println(infectedCount)
}
