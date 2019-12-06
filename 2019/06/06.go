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

func pathToCOM(key string, route []string, orbits map[string]string) []string {
	route = append(route, key)

	next_key, ok := orbits[key]
	if !ok {
		return route
	}
	return pathToCOM(next_key, route, orbits)
}

func arrayIndex(key string, array []string) (index int) {
	for i, v := range array {
		if key == v {
			return i
		}
	}
	return -1
}

func hackyShortestPath(key string, routes_you []string, routes_san []string) (distance int) {
	for i, o := range routes_you {
		f := arrayIndex(o, routes_san)
		if f != -1 {
			return i + f - 2
		}
	}
	return -1
}

func main() {
	filename := os.Args[1]
	orbits := loadFile(filename)

	routes_san := pathToCOM("SAN", make([]string, 0), orbits)
	routes_you := pathToCOM("YOU", make([]string, 0), orbits)
	// fmt.Println(routes_you, routes_san)
	res := hackyShortestPath("YOU", routes_you, routes_san)

	fmt.Println(res)
}
