So, I want a TTL CPU
8 bit data, 16 bit address

instruction format:
oootttwi iiiiiiii
8 opcodes with 8 subtypes

operations will use the accumulator as s1 and dest

program test case:

call a function in a function pointer that has a branch in it that returns a value

internal function does 16 bit arithmetic

I will need add with carry and status clear instructions
awc

also load to mar

load to accumulator
store to accumulator

load memory
store memory


in C, what does my test case look like?

Or just python

def test_case(a: 16, b: 16):
	return op(a, b)

def op_add(a: 16, b: 16):
	if a == 0:
		return b
	else:
		return a + b

op = op_add

.data
op:	addr(op_add)

.text

test_case:
	build stack
	load address of op
	load op
	move op to mar
	branch
	tear down stack
	return

op_add:
	build stack
	set return value to zero
	do check (on 16 bits? how? how do I do this with 16 bits?)
	load branch address to mar
	test hi (load from zp, then test)
	branch if false
	test lo
	branch if true
	clear flags
	add lo
	store to return zp
	add hi
	store to return zp

return_op_add:
	tear down stack
	return (load to mar, then branch unconditionally)

main:
	call test_case

\_start:
	set up stack
	set up globals
	call main

ok, I need the alu instructions to test, then mar load


registers needed:
plain:
A - 8 bit accumulator
B - 8 bit immediate/zp value from instruction
IR - 8 bit instruction value
LR - 16 bit link register. PC value goes here when branching.
SR - 4 bit status register with status from alu. CZON
counter:
PC - 16 bit program counter
MAR - 16 bit memory address register. Also counter. Address for memory ops and branches


So it looks like there will be 6 plain register chips, each with a buffer. B will probably have 2 buffers, one for data and one for address. IR has no buffer, it just reads from data.

Counters each need 4 chips (193s) + 2 buffers per. This comes out to 6 chips per, so 12 total.

alu needs 8 luts + 2 adders + whatever I need for shifting. Basically stealing gigatron's alu and putting in left and right shift. Plus a buffer for the data bus.

Wait, I can make the A register a shift register - 2x194s and then a buffer. Just have to work it into the control logic. Yeah, that will work.

So, now we have:
ALU instructions:
add
sub
and
or
xor
not
sl - shift left
sr - shift right

MAR/link instructions:
mar hi
mar lo
inc mar
dec mar
link hi
link lo

load:
mem val to acc/zp
val to A

store:
acc/zp to mem
A to zp

branch:
always
equal
not equal
less than
greater than
carry
overflow

clear flags:
clrf


Pipeline stages:
fetch:
PC->addr->mem, PC++, mem->data->IR

decode:
PC->addr, PC++, mem->data->B
determine if we need to zp. if so, do zp stage, else do execute
stretch goal: check if we can skip this stage for zero-op instructions

zp:
zp+B->addr, mem->data->B

Execute:
Do the funky instruction-specific stuff

	ALU Instructions:
	ALU->data->A, set flags

	Branch:
		if branch valid, then
		PC->addr->LR
		tick
		MAR->addr->PC
	
	Store:
	MAR->addr, [A or B]->data->mem

	Load:
	MAR->addr, mem->data->A

	Load accumulator:
	B->data->A

	Move from accumulator: (I could make this into its own stage for optimization)
	zp+B->addr, A->data->mem

	load MAR:
	[A or B]->data->MAR[Hi or lo]

	Link: (see how easy it would be to do this to zp)
	LR[Hi or lo]->data->A




control signals:
pc read
pc write 
pc inc
mar hi
mar lo
mar read
mar inc
link write
link hi
link lo
IR latch
A read
A write
A left
A right
B read
B write
B fast page
status register
stage register
	if
	decode
	imm
	fp
	execute



Ok, new set of stages from phone:
IF:
Pc->addr->mem->ir, PC inc.
Go to decode.

Decode: determine next state. Might be able to optimize this out later.
	# decode step lets us do 0 op instructions
If OP is nop, go to IF
If W is hi, go to imm.
If W is lo, go to execute.

Imm:
Pc->addr->mem->data->B, PC inc.
If I is hi, go to Execute
If I is lo, go to fp.

FP:
Bfc->addr->mem->data->B
Go to execute

Execute:
Depends on opcode/type.

	ALU:
	A B ->ALU->A

	Branch:
	If branch valid for status/type:
	Pc->addr->link, tick, then mar->addr->PC
		(don't even have to tick, just hook up the link register before the 
	Else:
	Go to IF

	Load:
	MAR->addr->mem->data->A

	Store:
	MAR->addr->mem, A->data->mem

	Move from accumulator:
	Bfp->addr->mem, A->data->mem

	Move to accumulator:
	B->data->A

	Link:
	Hi/lo->data->A

	Mar:
	A->data->mar hi/lo

	Inc mar:
	Inc line to mar. 


control signal formulas:
stage register
	if
		(NOP and Decode) or (Execute)
	decode
		IF
	imm
		(Decode and not NOP and W)
	fp
		(imm and not I)
	execute
		(decode and not W) or (imm and I) or (FP)
pc to bus
	IF or imm
pc from bus
	Execute and branch valid
pc inc
	IF or imm
mar hi
	execute and mar and hi
mar lo
	execute and mar and lo
mar read
	execute and branch
mar inc
	execute and mar_inc
link write
	execute and branch valid
link hi
	execute and link and hi
link lo
	execute and link and lo
IR latch
	IF
A to bus
	execute and (mfa or store or mar)
A write
	execute and (mta or load or link or (alu and not shift))
A left
	execute and ALU and type_is_left
A right
	execute and ALU and type_is_right
B to bus
	execute and mta
B from bus
	imm and FP
B fast page
	(FP) and (execute and mfa)
status register
	ALU


instruction format:
oootttwi [iiiiiiii]

So we have 8 bits to play with and I want immediate and width to be single bits.

I now have 6 real ALU instructions because I now have shifts.

ALU: add, sub, and, or, xor, not, (left, right?, or with carries?)
Load
Store
Link
Branch
MAR: hi, lo, inc
Move to accumulator
Move from accumulator
Halt
NOP

I also want stop, step, start, and reset. 
Stop, step, and start will mess with the clock.
I think halt will too.
Reset will 
From SSC Discord: Asinar
Many oscillators have an "output enable" that you should use instead.
That will disable the clock at a specific edge, to make sure high/low times are not violated.


Then be able to use a front panel with switches to load in data to memory.
Memory map a display register and an input set of switches with an enter button.
















