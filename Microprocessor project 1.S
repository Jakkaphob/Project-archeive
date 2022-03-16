	.thumb
	.syntax unified
	.equ GPIOA_CRL,		0x40010800 @slot 0-7control
	.equ GPIOA_ODR,		0x4001080C @control_data_opt
	.equ STACKINIT,		0x20005000
	.equ RCC_APB2ENR,	0x40021018 @clock
	.equ LEDDELAY,		2000000 @around 0.8 sec

.section .text
		 .org 0

vectors:
	.word STACKINIT
	.word _start + 1

.global _start

_start:
	LDR R6, = RCC_APB2ENR
	MOV R0, 0x04 @R0 = constant base 16 so its 4(xxxx)
	STR R0, [R6]
	LDR R6, = GPIOA_CRL @[R6] = variable for show LED
	LDR R0, = 0x33333333
	STR R0, [R6]
	LDR R6, = GPIOA_ODR
again: MOV R2, 1
loop:
	STR R2, [R6]
	LSL R2, #1
	LDR R1, = LEDDELAY

led_move:
	SUBS R1, 1 @subtract value of r1 by 1 until it reach 1
	BNE led_move @if not equal, go back from the bottom(the value of R1 will be subtract again until R1 value is equal to 1)
	CMP R2, #0x100 @compare R2 value if it equal to 0x100(256 if converted from hexa to decimal -> 2^8 = 256 so its 8) use as a check point of each led
	BNE loop @if binary not equal move led to left by 1(led start at the right most)
	MOV R2, 37 @if binary equal, R2 will move it value to 37 aka first id
	STR R2, [R6]
	LDR R1, = LEDDELAY
id2:
	SUBS R1, 1
	BNE id2
	MOV R2, 9
	STR R2, [R6]
	LDR R1, = LEDDELAY
id3:
	SUBS R1, 1
	BNE id3
	MOV R2, 23
	STR R2, [R6]
	LDR R1, = LEDDELAY


	