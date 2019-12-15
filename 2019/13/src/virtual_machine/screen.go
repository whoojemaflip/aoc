package virtual_machine

import "fmt"

type Screen [][]int

func NewScreen(width, height int) Screen {
	screen := make([][]int, height)
	for i := 0; i < height; i += 1 {
		screen[i] = make([]int, width)
	}
	return screen
}

func (screen *Screen) Update(x, y int, tile int) {
	line := (*screen)[y]
	line[x] = tile
	(*screen)[y] = line
}

func (screen Screen) Print(tiles map[int]string) {
	fmt.Printf("\n")
	for y := 0; y < len(screen); y += 1 {
		for x := 0; x < len(screen[y]); x += 1 {
			tile_id := screen[y][x]
			fmt.Print(tiles[tile_id])
		}
		fmt.Printf("\n")
	}
	fmt.Printf("\n")
}
