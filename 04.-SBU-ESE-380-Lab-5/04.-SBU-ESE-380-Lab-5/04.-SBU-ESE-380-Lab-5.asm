; duty_cycle.asm: Simple program that generates a variable duty cycle pulses
;           waveform. The duty cycle will range from 10% to 90% and will be 
;           adjustable in 10% increments. The duty cycle is user settable 
;           via BCD value provided on the lower nibble of the DIP switch. 
;
; inputs: PBSW1 and PC0
;         DIP-8 switch, PD0 to PD7
; outputs: 7-segment display, 8 LEDs, PB0 to PB7, active low
;          LED being control through PWM at PA0
;
; assumes: nothing
; alters: r16, r17, r18, r19, r20, r22 
;
; Author: Paultre/Saied  10/08/14
; Lab Number: 5
; Lab Section: 4
; Lab Bench: 5

;Load include file(s) 
.nolist
.include "m16Adef.inc"          ;include part specific header
.list

reset:
    ;Configure stack pointer
    ldi r19, HIGH (RAMEND)      ;load high byte of last address
    out SPH, r19                ;in SRAM into SPH
    ldi r19, LOW (RAMEND)       ;load low byte of last address
    out SPL, r19                ;in SRAM into SPL
    ;Configure port B as an output port
    ldi r16, $FF                ;load r16 with all 1s
    out DDRB, r16               ;port B - all bits configured as outputs
    ldi r16, $C0                ;load r16 with bit pattern to output 0
    out PORTB, r16              ;on the 7-segment display
    ;Configure port D as an input port
    ldi r16, $00                ;load r16 with all 0s
    out DDRD, r16               ;port D - all bits configured as inputs
    ldi r16, $FF                ;enable pull-up resistors by outputting
    out PORTD, r16              ;all 1s to PORTD
    ;Configure bit 0 of port C as an input bit
    cbi DDRC, 0                 ;clear bit 0 of port C setting it up as an input
    sbi PORTC, 0                ;setting bit 0 of port C enabling its associated
                                ;pull-up resistor
    ;Configure bit 0 of port A as an output port
    sbi DDRA, 0                 ;set bit 0 of port A as output
    cbi PORTA, 0                ;clear bit 0 of port A to make sure our signal
                                ;starts at a logic 0

delay_1:
    ;Verifying that the switch is released
    sbis PINC, 0                ;skip the next instruction if PINC0 set
    rjmp delay_1                ;restart the delay_1 loop if button is pressed
    
delay_0:
    ;Waiting for the switch to get pressed
    sbic PINC, 0                ;skip the next instruction if PINC0 clear
    rjmp delay_0                ;restart the delay_0 loop if button not pressed
    rcall delay_10ms            ;wait 10ms to go beyond the bouncing switch
    sbic PINC, 0                ;skip the next instruction if PINC0 clear
    rjmp delay_0                ;restart the delay_0 loop
    in r21, PIND                ;read the DIP switch
    andi r21, $0F               ;masks the higher nibble of the switches
    breq delay_0                ;invalid value of the lower nibble waits for
                                ;push of the button
    cpi r21, 10                 ;if r21 >= 10 it's an invalid value for the 
    brsh delay_0                ;lower nibble and waits for next push of the 
                                ;button

duty_cycle:
    ;Determine the actual duty cycle and output it
    sbis PINC, 0                ;skip the next instruction if PINC0 set
    rjmp duty_cycle             ;wait for the switch to be back to unpressed
                                ;position before processing
    mov r18, r21                ;copy the contents of r21 to r18 and output
    rcall bcd_7seg              ;them to the 7 segment LED display
    cpi r21, 1                  ;if r21 = 1 jump to 10% and output a 10% duty
    breq 10%                    ;cycle pulse at 1 KHz
    cpi r21, 2                  ;if r21 = 2 jump to 20% and output a 20% duty
    breq 20%                    ;cycle pulse at 1 KHz
    cpi r21, 3                  ;if r21 = 3 jump to 30% and output a 30% duty
    breq 30%                    ;cycle pulse at 1 KHz
    cpi r21, 4                  ;if r21 = 4 jump to 40% and output a 40% duty
    breq 40%                    ;cycle pulse at 1 KHz
    cpi r21, 5                  ;if r21 = 1 jump to 50% and output a 50% duty
    breq 50%                    ;cycle pulse at 1 KHz
    cpi r21, 6                  ;if r21 = 1 jump to 60% and output a 60% duty
    breq 60%                    ;cycle pulse at 1 KHz
    cpi r21, 7                  ;if r21 = 1 jump to 70% and output a 70% duty
    breq 70%                    ;cycle pulse at 1 KHz
    cpi r21, 8                  ;if r21 = 1 jump to 80% and output a 80% duty
    breq 80%                    ;cycle pulse at 1 KHz
    cpi r21, 9                  ;if r21 = 1 jump to 90% and output a 90% duty
    breq 90%                    ;cycle pulse at 1 KHz

10%:
    sbi PORTA, 0                ;start of the pulse
    rcall delay_100us           ;wait 100 us
    cbi PORTA, 0                ;end of pulse
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    sbis PINC, 0    			;verify that the switch is still pressed
    rjmp delay_0				;if not go back to checking the switch
	rjmp 10%					;if still pressed output another pulse

20%:
    sbi PORTA, 0                ;start of the pulse
    rcall delay_100us           ;wait 100 us
    rcall delay_100us
    cbi PORTA, 0                ;end of pulse
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    sbis PINC, 0        		;verify that the switch is still pressed
    rjmp delay_0				;if not go back to checking the switch
	rjmp 10%					;if still pressed output another pulse

30%:
    sbi PORTA, 0                ;start of the pulse
    rcall delay_100us           ;wait 100 us
    rcall delay_100us
    rcall delay_100us
    cbi PORTA, 0                ;end of pulse
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    sbis PINC, 0        		;verify that the switch is still pressed
    rjmp delay_0				;if not go back to checking the switch
	rjmp 10%					;if still pressed output another pulse

40%:
    sbi PORTA, 0                ;start of the pulse
    rcall delay_100us           ;wait 100 us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    cbi PORTA, 0                ;end of pulse
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    sbis PINC, 0        		;verify that the switch is still pressed
    rjmp delay_0				;if not go back to checking the switch
	rjmp 10%					;if still pressed output another pulse

50%:
    sbi PORTA, 0                ;start of the pulse
    rcall delay_100us           ;wait 100 us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    cbi PORTA, 0                ;end of pulse
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    sbis PINC, 0        		;verify that the switch is still pressed
    rjmp delay_0				;if not go back to checking the switch
	rjmp 10%					;if still pressed output another pulse

60%:
    sbi PORTA, 0                ;start of the pulse
    rcall delay_100us           ;wait 100 us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    cbi PORTA, 0                ;end of pulse
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    sbis PINC, 0        		;verify that the switch is still pressed
    rjmp delay_0				;if not go back to checking the switch
	rjmp 10%					;if still pressed output another pulse

70%:
    sbi PORTA, 0                ;start of the pulse
    rcall delay_100us           ;wait 100 us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    cbi PORTA, 0                ;end of pulse
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    sbis PINC, 0        		;verify that the switch is still pressed
    rjmp delay_0				;if not go back to checking the switch
	rjmp 10%					;if still pressed output another pulse

80%:
    sbi PORTA, 0                ;start of the pulse
    rcall delay_100us           ;wait 100 us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    cbi PORTA, 0                ;end of pulse
    rcall delay_100us
    rcall delay_100us
    sbis PINC, 0        		;verify that the switch is still pressed
    rjmp delay_0				;if not go back to checking the switch
	rjmp 10%					;if still pressed output another pulse

90%:
    sbi PORTA, 0                ;start of the pulse
    rcall delay_100us           ;wait 100 us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    rcall delay_100us
    cbi PORTA, 0                ;end of pulse
    rcall delay_100us
    sbis PINC, 0        		;verify that the switch is still pressed
    rjmp delay_0				;if not go back to checking the switch
	rjmp 10%					;if still pressed output another pulse

; delay_100us - A self-contained 100 us software delay useful for modulating
;       the width of a pulse and it's associated trough. The delay is a simple
;       decrementing counter unable to be used for anything else
;       
;
; inputs: delay loop counts
; outputs: none
;
; ATmega clock frequency = 1 MHz
; calls: none
; program memory words: 0x0004
;
; registers altered:
;       r22 = outer loop delay count
;       SREG
; Author: Paultre/Saied

set:
    ldi r22, $1E                ;load delay count value
delay_100us:
    dec r22                     ;decrement delay count value
    brne delay_100us            ;if 0 fall through
    ret                         ;return to the instruction before the subroutine
    
; delay_10ms - A self-contained 10 ms software delay useful for debouncing
;       typical pushbutton switches. The delay is a common inner-outer dual
;       loop type, which can be used with larger values to generate a longer
;       delay.
;
; inputs: delay loop counts for the outer and inner loops
; outputs: none
;
; ATmega clock frequency = 1 MHz
; calls: none
; program memory words: 0x0008
;
; registers altered:
;       r20 = outer loop delay count
;       r17 = inner loop delay count.
;       SREG
; Author: Paultre/Saied

delay_10ms:
    ldi r20, 10                 ;load outer delay count value
o_loop:
    ldi r17, $F9                ;load r17 with 250 to count down clock cycles
i_loop:
    nop                         ;waste a clock cycle
    dec r17                     ;decrement r17
    brne i_loop                 ;if 0 fall through
    nop                         ;waste a clock cycle
    dec r20                     ;decrement r20
    brne o_loop                 ;if 0 fall through
    ret                         ;go back to the instruction after the call
    
; bdc_7seg - A self-contained software useful for displaying binary numbers
;       in BCD format onto a 7 segment display. The software first acquires
;       the number to be displayed from the main program and adds it to the
;       low byte of our table and adds the carry to the high byte of our 
;       pointer. This creates the bit pattern for our number into the pointer.
;       This will then be loaded into the register which is outputted to the
;       port for display.
; 
; inputs: contents of the table to be placed into the pointer and value 
;         from program
; outputs: bit pattern to display the value inputted from program
;
; calls: none
; program memory words: 0x0008
;
; registers altered:
;       r16 = cleared in order to add just the carry to high byte of pointer
;       r18 = added to the low by of the pointer
; 
; Author: Paultre/Saied

bcd_7seg:
    ldi ZH, high (table * 2)    ;set Z to point to start of table
    ldi ZL, low (table * 2)     ;
    ldi r16, $00                ;clear for later use
    add ZL, r18                 ;add low byte
    adc ZH, r16                 ;add in the carry
    lpm r18, Z                  ;load bit pattern from table into r18
display:
    out PORTB, r18              ;output pattern for 7-seg display count
    ret                         ;jump back to read the switches again
    
    ;table of 7-segment bit patterns to display digits 0-9
table: .db $C0,$F9,$A4,$B0,$99,$92,$82,$F8,$80,$90
           ; 0   1   2   3   4   5   6   7   8   9  ?A? . . .
