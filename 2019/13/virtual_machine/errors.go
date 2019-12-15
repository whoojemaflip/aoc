package virtual_machine

type Halt string

func (e Halt) Error() string {
	return string(e)
}

type Yield string

func (e Yield) Error() string {
	return string(e)
}
