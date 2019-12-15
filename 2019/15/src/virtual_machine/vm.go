package virtual_machine

import "fmt"

type VM struct {
	pc            uint64
	input_buffer  []int64
	output_buffer []int64
	memory        Memory
	registers     map[int]int64
	instructions  map[int]Opcode
	debug         bool
}

func NewVM(filename string) VM {
	return VM{
		0,
		make([]int64, 10),
		make([]int64, 0),
		NewMemory(filename),
		make(map[int]int64),
		Instructions,
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
		Instructions,
		true,
	}
}

func NewInteractiveVM(filename string) VM {
	return VM{
		0,
		make([]int64, 10),
		make([]int64, 0),
		NewMemory(filename),
		make(map[int]int64),
		InteractiveInstructions(),
		false,
	}
}

func (vm VM) String() string {
	//fmt.Printf("pc: %v, regs: %v\nmem: %v\n", vm.pc, vm.registers, vm.memory)
	return fmt.Sprintf("pc: %v, regs: %v\n", vm.pc, vm.registers)
}

// exported alias for memory.poke
func (vm *VM) SetMem(addr, value int) {
	vm.memory.poke(uint64(addr), int64(value))
}

func (vm *VM) Process() error {
	for {
		if vm.debug {
			fmt.Printf("%5d ", vm.pc)
		}

		instruction := vm.memory.peek(vm.pc)
		code, parameter_modes := decode_instruction(instruction)
		opcode, ok := vm.instructions[code]
		if !ok {
			panic(fmt.Sprintf("Opcode not found at %v", vm.pc))
		}

		if vm.debug {
			fmt.Printf("%4d", instruction)

			for j := 1; j <= opcode.arity; j++ {
				fmt.Printf(" %4d", vm.memory.peek(vm.pc+uint64(j)))
			}
		}

		args := prepare_args(opcode.arity, parameter_modes, vm)

		vm.pc += uint64(opcode.arity + 1)

		if vm.debug {
			fmt.Printf(" // %v %v\n", opcode.name, args)
		}

		err := opcode.calc(args, vm)

		if err != nil {
			return err
		}
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
