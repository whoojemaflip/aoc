package virtual_machine

// Register 0 holds the the Relative Address

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
