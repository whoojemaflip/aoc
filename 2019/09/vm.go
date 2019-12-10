package main

import "fmt"

type VM struct {
	pc            uint64
	input_buffer  []int64
	output_buffer []int64
	memory        Memory
	registers     map[int]int64
	debug         bool
}

func NewVM(filename string) VM {
	return VM{
		0,
		make([]int64, 10),
		make([]int64, 0),
		NewMemory(filename),
		make(map[int]int64),
		false,
	}
}

func NewDebugVM(filename string) VM {
	return VM{
		0,
		make([]int64, 10),
		make([]int64, 0),
		NewMemory(filename),
		make(map[int]int64),
		true,
	}
}

func (vm VM) Dump() {
	//fmt.Printf("pc: %v, regs: %v\nmem: %v\n", vm.pc, vm.registers, vm.memory)
	fmt.Printf("pc: %v, regs: %v\n", vm.pc, vm.registers)
}

func (vm *VM) Process() error {
	for {
		if vm.debug {
			vm.Dump()
		}

		instruction := vm.memory.peek(vm.pc)
		code, parameter_modes := decode_instruction(instruction)
		opcode, ok := Instructions[code]
		if !ok {
			panic(fmt.Sprintf("Opcode not found at %v", vm.pc))
		}
		args := prepare_args(opcode.arity, parameter_modes, vm)

		vm.pc += uint64(opcode.arity + 1)

		if vm.debug {
			fmt.Printf("%v %v\n\n", opcode.name, args)
		}

		err := opcode.calc(args, vm)

		if err != nil {
			return err
		}
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

func decode_instruction(instruction int64) (opcode int, parameter_modes []int) {
	opcode = int(instruction % 100)
	instruction = instruction / 100
	for {
		if instruction == 0 {
			break
		}

		mode := int(instruction % 10)
		parameter_modes = append(parameter_modes, mode)

		instruction = instruction / 10
	}

	return
}

func prepare_args(arity int, parameter_modes []int, vm *VM) (args []Arg) {
	for i := 0; i < arity; i++ {
		var mode int
		if i >= len(parameter_modes) {
			mode = 0
		} else {
			mode = parameter_modes[i]
		}
		value := vm.memory.peek(vm.pc + uint64(i) + 1)
		arg := vm.NewArg(value, mode)
		args = append(args, arg)
	}
	return
}

func (vm VM) readFromInputBuffer() int64 {
	out := vm.input_buffer[0]
	if vm.debug {
		fmt.Printf("Input %v\n\n", out)
	}
	vm.input_buffer = vm.input_buffer[1:]
	return out
}

func (vm *VM) writeToOutputBuffer(val int64) {
	vm.output_buffer = append(vm.output_buffer, val)
}

func (vm VM) DumpOutputBuffer() {
	fmt.Println(vm.output_buffer)
}

func (vm VM) ReadRegister(r int) int64 {
	return vm.registers[r]
}

func (vm *VM) WriteRegister(r int, v int64) {
	vm.registers[r] = v
	return
}

func (vm *VM) IncRegister(r int, v int64) {
	vm.WriteRegister(r, vm.ReadRegister(r)+v)
}
