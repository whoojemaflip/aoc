package virtual_machine

import "fmt"

type Arg struct {
	mode     int
	value    int64
	addr     uint64
	resolved int64
}

func (arg Arg) String() string {
	if arg.mode == 0 {
		return fmt.Sprintf("p(%v)[%v]", arg.value, arg.resolved)
	} else if arg.mode == 1 {
		return fmt.Sprintf("l(%v)", arg.value)
	} else if arg.mode == 2 {
		return fmt.Sprintf("r(%v)[%v][%v]", arg.value, arg.addr, arg.resolved)
	} else {
		panic("arg mode unrecognized")
	}
}

func (vm VM) NewArg(value int64, mode int) Arg {
	if mode == 0 {
		return Arg{
			0,
			value,
			uint64(value),
			vm.memory.peek(uint64(value)),
		}
	} else if mode == 1 {
		return Arg{
			1,
			value,
			uint64(value),
			value,
		}
	} else if mode == 2 {
		addr := uint64(vm.ReadRegister(0) + value)

		return Arg{
			2,
			value,
			addr,
			vm.memory.peek(addr),
		}
	} else {
		panic("Value can't be resolved.")
	}
}
