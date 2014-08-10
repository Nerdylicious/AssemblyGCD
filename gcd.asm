;Author: Irish Medina

;Purpose: Computes gcd of 2 numbers

;data dictionary for main:
;R0 - the result, gcd(a,b)
;R1 - argument 1 which is passed to stack
;R2 - argument 2 which is passed to stack
;R6 - stack pointer

	.orig	x3000
	
main

	and	r0,r0,#0
	and	r1,r1,#0
	and	r2,r2,#0
	and	r3,r3,#0
	and	r4,r4,#0
	and	r5,r5,#0
	and	r6,r6,#0
	and	r7,r7,#0

	ld	r6,stackbase	;initialize stack pointer to 0x4000

	ld	r1,a		;load a
	ld	r2,b		;load b

	add	r6,r6,#-1	;push arg a onto stack
	str	r1,r6,#0

	add	r6,r6,#-1	;push arg b onto stack
	str	r2,r6,#0

	add	r6,r6,#-1	;set aside one word for return value

	jsr	gcd

	ldr	r0,r6,#0	;get return value and put into r0
	st	r0,result	;store the result in memory

	add	r6,r6,#3	;remove 2 args from stack and return value

	halt

;subroutine gcd - computes the gcd of two numbers passed on the stack

;data dictionary for subroutine:
;R0 - value of c
;R1 - value of a (parameter 1), also value to be returned
;R2 - value of b (parameter 2)
;R3 - value of (-b)
;R4 - a temporary for doing calculations
;R5 - frame pointer
;R6 = stack pointer 

;stack contents:
;r5 + 0 - return value
;r5 + 1	- parameter 2
;r5 + 2 - parameter 1

gcd

	add	r6,r6,#-1	;save r5
	str	r5,r6,#0

	add	r5,r6,#1	;make r5 point to return value
	
	add	r6,r6,#-1	;save r1
	str	r1,r6,#0

	add	r6,r6,#-1	;save r2
	str	r2,r6,#0	

	add	r6,r6,#-1	;save r7
	str	r7,r6,#0

	and	r1,r1,#0
	and	r2,r2,#0
	and	r7,r7,#0

	ldr	r1,r5,#2	;load first parameter to r1
	brz	done		;done if arg is 0

	ldr	r2,r5,#1	;load second parameter to r2
	brz	done		;done if arg is 0

while_not_equal			;while a <> b

	not	r3,r2
	add	r3,r3,#1	;r3 is -b

	and	r4,r4,#0
	add	r4,r1,r3	;a - b

	brp	while_a_greater
	brn	while_b_greater
	brz	done

while_a_greater			;while a > b

	and	r3,r3,#0
	not	r3,r2
	add	r3,r3,#1	;get -b

	and	r0,r0,#0
	add	r0,r1,r3	;c = a -  b
	and	r1,r1,#0
	add	r1,r1,r0	;a = c

	and	r4,r4,#0
	add	r4,r1,r3	;a - b

	brp	while_a_greater
	brn	while_b_greater
	brz	done		;they are the same

while_b_greater			;while b > a

	and	r7,r7,#0
	not	r7,r1
	add	r7,r7,#1	;get -a

	and	r0,r0,#0
	add	r0,r2,r7	;c = b - a
	and	r2,r2,#0
	add	r2,r2,r0	;b = c

	and	r4,r4,#0
	add	r4,r2,r7	;b - a

	brp	while_b_greater
	brnz	while_not_equal
	
done	

	and	r4,r4,#0	;check if one of arguments is 0
	add	r4,r1,#0
	brz	if_zero

	and	r4,r4,#0
	add	r4,r2,#0
	brz	if_zero
	brnp	continue

if_zero
	and	r1,r1,#0	;return value must be 0 if at least one or args is 0
	br	continue

continue	

	;gcd(a,b) = a = b
	str	r1,r5,#0	;put result onto stack
	
	ldr	r7,r6,#0	;restore r7
	add	r6,r6,#1

	ldr	r2,r6,#0	;restore r2
	add	r6,r6,#1

	ldr	r1,r6,#0	;restore r1
	add	r6,r6,#1

	ldr	r5,r6,#0	;restore r5
	add	r6,r6,#1

	ret			;return to caller

;end of subroutine gcd

stackbase .fill	 x4000

a	.fill	#66
b	.fill	#12

result	.fill	#0

	.end
