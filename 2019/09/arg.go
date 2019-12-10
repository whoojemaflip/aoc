package main

import "fmt"

type Arg struct {
	mode     int
	value    int64
	addr     uint64
	resolved int64
}

func (arg Arg) String() string {
	if arg.mode == 0 {
		return fmt.Sprintf("peek(%v) -> %v", arg.value, arg.resolved)
	} else if arg.mode == 1 {
		return fmt.Sprintf("literal(%v)", arg.value)
	} else if arg.mode == 2 {
		return fmt.Sprintf("relative(%v) -[%v]-> %v", arg.value, arg.addr, arg.resolved)
	} else {
		panic("arg mode unrecognized")
	}
}
