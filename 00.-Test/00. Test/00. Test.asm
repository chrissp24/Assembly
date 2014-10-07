; inout.asm : Simple program to display the positions
;	 of 8 SPST switches on 8 LEDs. If the switch is a 
;	 logic-1, the corresponding LED is on. If the sw
;	 is a logic-0, the LED is off
;
; inputs: DIP-8 Switch, PD0 to PD7
; outputs: Bargraph, 8 LEDs, PB0 to PB7, active low
;
; assumes: nothing
; alters: r16, SREG
;
; Author: KLS/FST
; Updated: Paultre Saeid 09/18/14
; Version: 1.1


.nolist
.include "m16Adef.inc"	;include part specific header
.list

reset:
	; Configure I/O ports (1-pass only!)
	ldi r16, $FF		;load r16 with all 1s
	out DDRB, r16		;PORTB - all bits configured as outputs
	ldi r16, $00		;load r16 with all 0s
	out DDRD, r16		;PORTD - all bits configured as inputs

	; Infinite loop. Input switch values, and output to LEDs
again:
	in r16, PIND		;read switch values
	com r16				;complement switch values to drive LEDs
	out PORTB, r16		;output to LEDs values read from switches
	rjmp again			;continually repeat previous two instructions