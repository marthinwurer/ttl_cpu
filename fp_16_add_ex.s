
	; little endian for ease of use
	; stack pointer is zp ff:fe
	; zp ra is fc:fd
	; volatile memory is upper half
	; arguments in fp 20-30 because I need to put them somewhere for this example.

.data
op:	op_add

.text

test_case:
	; build stack
	; so what do I want to do now?
	; I can store the link in a ra zp space
	; then I can push it on the stack
	; then I can increment the stack by that much.
	; set address to stack
	lhi fc ; make this a macro
	llo fd

	mal fe ; make this a macro too
	mah ff

	mai ; increment mar
	sto fc
	mai
	sto fd ; it's this or have a stack register and push and pop
	
	; add the two that we incremented to the stack pointer
	clrf
	lda ff
	add #2
	mfa ff
	lda fe
	add #0
	mfa fe
	
	; now I want to load the address of the function pointer
	mal #op_lo
	mah #op_hi
	
	load  ; index it!
	mfa 10  ; low byte
	mai
	load
	mfa 11  ; hi byte

	; now to jump there
	mal 10
	mah 11
	jump

	; tear down the stack
	; pop ra back off the stack

	; pop off the stack
	load fd
	mad
	load fc
	mad

	; decrement sp
	clrf
	lda ff
	sub #2
	mfa ff
	lda fe
	sub #0
	mfa fe

	; return
	mal fd
	mah fc
	jump



op_add:
	; build stack
	; store the ra
	lhi fc ; make this a macro
	llo fd

	mal fe ; make this a macro too
	mah ff

	mai ; increment mar
	sto fc
	mai
	sto fd ; it's this or have a stack register and push and pop
	; push other affected fps onto stack
	; 10 and 11 are going to be reused as the returned value
	mai ; increment mar
	sto 10
	mai
	sto 11 ; it's this or have a stack register and push and pop
	
	; add the 4 that we incremented to the stack pointer
	clrf
	lda ff
	add #4
	mfa ff
	lda fe
	add #0
	mfa fe

	; I will definitely need a macro for start of function

	; meat of the function
	mal skip_lo
	mah skip_hi

	clrf
	lda 21 ; test hi then lo
	sub 0
	beq
	lda 20
	sub 0
	beq

	; now do the math
	clrf
	add 22
	mfa 10
	lda 21
	add 23
	mfa 11
skip:	
	; return

	; pop off the stack
	load 11
	mad
	load 10
	mad
	load fd
	mad
	load fc
	mad

	; decrement sp
	clrf
	lda ff
	sub #4
	mfa ff
	lda fe
	sub #0
	mfa fe

	; return
	mal fd
	mah fc
	jump



	

main:
	; set up stack
	lda #stackupper
	mfa ff
	lda #stacklower
	mfa fe

	; need to figure out a macro for this
	lda test_case_upper
	mah ; memory address high
	lda test_case_lower
	mal ; memory address low

	jump ; don't even need a macro for this



	; jump to exit


	
