#include<p18F4550.inc>

loop_cnt	equ	0x00
loop_cnt1	equ	0x01

			org 0x00
			goto start
			org 0x08
			retfie
			org 0x18
			retfie

dup_nop 	macro n
			variable i
i=0
			while i < n
			nop
i+=1
			endw
			endm

;****************************************************************
;           delay 

delay		movlw	D'20'
			movwf	loop_cnt1,A
again1		movlw	D'250'
			movwf	loop_cnt,A
again		dup_nop	D'17'
			decfsz	loop_cnt,F,A
			bra		again
			decfsz	loop_cnt1,F,A
			bra		again1
			return



;****************************************************************
;           keypad configuration subroutine

keyA		bsf		PORTB,4,A
			bcf		PORTB,5,A
			bcf		PORTB,6,A
			bcf		PORTB,7,A
			return
keyB		bcf		PORTB,4,A
			bsf		PORTB,5,A
			bcf		PORTB,6,A
			bcf		PORTB,7,A
			return
keyC		bcf		PORTB,4,A
			bcf		PORTB,5,A
			bsf		PORTB,6,A
			bcf		PORTB,7,A
			return
keyD		bcf		PORTB,4,A
			bcf		PORTB,5,A
			bcf		PORTB,6,A
			bsf		PORTB,7,A
			return

;****************************************************************
;           keypad  subroutine

KEYPAD		movlw	B'00001110'
			movwf	TRISB,A
NUM1		call	keyA
			btfss	PORTB,1,A
			bra		NUM2
			call	show1	
NUM2		call	keyA
			btfss	PORTB,2,A
			bra		NUM3
			call	show2
NUM3		call	keyA
			btfss	PORTB,3,A
			bra		NUM4
			call	show3
NUM4		call	keyB
			btfss	PORTB,1,A
			bra		NUM5
			call	show4	
NUM5		call	keyB
			btfss	PORTB,2,A
			bra		NUM6
			call	show5
NUM6		call	keyB
			btfss	PORTB,3,A
			bra		NUM7
			call	show6
NUM7		call	keyC
			btfss	PORTB,1,A
			bra		NUM8
			call	show7	
NUM8		call	keyC
			btfss	PORTB,2,A
			bra		NUM9
			call	show8
NUM9		call	keyC
			btfss	PORTB,3,A
			bra		STAR
			call	show9
STAR		call	keyD
			btfss	PORTB,1,A
			bra		NUM0
			call	showstar	
NUM0		call	keyD
			btfss	PORTB,2,A
			bra		HASHTAG
			call	show0
HASHTAG		call	keyD
			btfss	PORTB,3,A
			bra		NUM1
			call	show#
			return
			
;****************************************************************
;            command subroutine

writecmd	bcf		PORTC,4,A
			bcf		PORTC,5,A
			bsf		PORTC,6,A
			call	delay
			bcf		PORTC,6,A
			return

;****************************************************************
;           send data command subroutine

sendDATA	bsf		PORTC,4,A
			bcf		PORTC,5,A
			bsf		PORTC,6,A
			call	delay
			bcf		PORTC,6,A
			return

;****************************************************************
;           configure LCD line 

line1		call	lcd
			movlw	0x80
			movwf	PORTD,A
			call	sendDATA
			return

line2		call	lcd
			movlw	0xC0
			movwf	PORTD,A
			call	sendDATA
			return

;****************************************************************
;           configure LCD 

lcd			movlw	B'00000110'
			movwf	TRISC,A
			clrf	TRISD,A
matrix		movlw	0x38
			movwf	PORTD,A
			call	writecmd
cursor		movlw	0x0E
			movwf	PORTD,A
			call	writecmd
clrdisplay	movlw	0x01
			movwf	PORTD,A
			call	writecmd
			return



;****************************************************************
;           display MYNAME subroutine

MYNAME	call	line1
		movlw	D'70'
		movwf	PORTD,A		;F
		call	sendDATA
		return

		movlw	D'65'
		movwf	PORTD,A		;A
		call	sendDATA
		return

		movlw	D'82'
		movwf	PORTD,A		;R
		call	sendDATA
		return

		movlw	D'73'
		movwf	PORTD,A		;I
		call	sendDATA
		return

		movlw	D'90'
		movwf	PORTD,A		;Z
		call	sendDATA
		return

;****************************************************************
;           display studentID subroutine

MYid	call	line1

		movlw	D'68'
		movwf	PORTD,A	;D
		call	sendDATA
		return

		movlw	D'69'
		movwf	PORTD,A	;E
		call	sendDATA
		return

		movlw	D'57'
		movwf	PORTD,A	;9
		call	sendDATA
		return

		movlw	D'55'
		movwf	PORTD,A	;7
		call	sendDATA
		return

		movlw	D'51'
		movwf	PORTD,A	;3
		call	sendDATA
		return

		movlw	D'53'
		movwf	PORTD,A	;5
		call	sendDATA
		return

		movlw	D'48'
		movwf	PORTD,A	;0
		call	sendDATA
;****************************************************************
;           display keypad subroutine

show1		call	line2
			movlw	D'49'	
			movwf	PORTD,A
			call	sendDATA
			return	
show2		call	line2
			movlw	D'50'	
			movwf	PORTD,A
			call	sendDATA
			return
show3	   	call	line2
			movlw	D'51'	
			movwf	PORTD,A
			call	sendDATA
			return	
show4		call	line2
			movlw	D'52'	
			movwf	PORTD,A
			call	sendDATA
			return
show5		call	line2
			movlw	D'53'	
			movwf	PORTD,A
			call	sendDATA
			return	
show6		call	line2
			movlw	D'54'	
			movwf	PORTD,A
			call	sendDATA
			return
show7		call	line2
			movlw	D'55'	
			movwf	PORTD,A
			call	sendDATA
			return	
show8		call	line2
			movlw	D'56'	
			movwf	PORTD,A
			call	sendDATA
			return
show9		call	line2
			movlw	D'57'	
			movwf	PORTD,A
			call	sendDATA
			return	
show0		call	line2
			movlw	D'48'	
			movwf	PORTD,A
			call	sendDATA
			return
showstar	call	line2
			movlw	D'42'	
			movwf	PORTD,A
			call	sendDATA
			return	
show#		call	line2
			movlw	D'35'	
			movwf	PORTD,A
			call	sendDATA
			return

;****************************************************************
;           main program

start		call	lcd
			movlw	B'00000110'
			movwf	TRISC,A
check1		BTFSS	PORTC,0,A
			bra		check2
			call	MYNAME
check2		BTFSS	PORTC,1,A
			bra		check1
			call	MYid
check3		call	KEYPAD
			bra		check1


			end