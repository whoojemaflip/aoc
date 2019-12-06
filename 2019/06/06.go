package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"strings"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func loadFile(filename string) map[string]string {
	data, err := ioutil.ReadFile(filename)
	check(err)
	orbits := strings.Split(strings.Trim(string(data), "\n"), "\n")

	out := make(map[string]string)
	for _, orbit := range orbits {
		objects := strings.Split(orbit, ")")
		out[objects[1]] = objects[0]
	}
	return out
}

func countGraphEdges(orbits map[string]string) int {
	fmt.Println(orbits)
	count := 0
	for _, v := range orbits {
		count += recurseEdgeCount(v, 0, orbits) + 1
	}
	return count
}

func recurseEdgeCount(key string, count int, orbits map[string]string) int {
	next_key, ok := orbits[key]
	if !ok {
		return count
	}
	count += 1
	if next_key == "COM" {
		return count
	} else {
		count = recurseEdgeCount(next_key, count, orbits)
		return count
	}
}

func main() {
	filename := os.Args[1]
	orbits := loadFile(filename)

	result := countGraphEdges(orbits)
	fmt.Println(result)
}
