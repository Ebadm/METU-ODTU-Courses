PROCESSOR 18F8722
    
#include <xc.inc>

; configurations
CONFIG OSC = HSPLL, FCMEN = OFF, IESO = OFF, PWRT = OFF, BOREN = OFF, WDT = OFF, MCLRE = ON, LPT1OSC = OFF, LVP = OFF, XINST = OFF, DEBUG = OFF

; global variable declarations
GLOBAL var1 , blinker_flag, re4_state, ra4_state
GLOBAL flag_num, bflag_num, cflag, level, AorD, d_leds;
GLOBAL _t1, _t2, _t3, D1,D2,D3, _m1, _m2, _m3    ; variables for time delay
    
; allocating memory for variables
PSECT udata_acs
    var1:
	DS 1    ; allocates 1 byte
    _t1:
        DS 1    ; allocate 1 byte
    _t2:
        DS 1    ; allocate 1 byte
    _t3:
        DS 1    ; allocate 1 byte
    _m1:
        DS 1    ; allocate 1 byte
    _m2:
        DS 1    ; allocate 1 byte
    _m3:
        DS 1    ; allocate 1 byte
    D1:
	DS 1
    D2:
	DS 1
    D3:
	DS 1
    level:
	DS 1
    AorD:
	DS 1
    d_leds:
	DS 1
    flag_num:
	DS 1	; allocate 1 bytes
    bflag_num:
	DS 1	; allocate 1 bytes
    cflag:
	DS 1	; allocate 1 bytes
    blinker_flag:
	DS 1	; allocate 1 bytes
    re4_state:
	DS 1	; allocate 1 bytes
    ra4_state:
	DS 1	; allocate 1 bytes	
PSECT resetVec,class=CODE,reloc=2
resetVec:
    goto    main


initialise:

    CLRF flag_num      ; initially, flag is set to 0
    CLRF bflag_num     ; flag for Port B is set to 0
    CLRF cflag         ; flag for Port C is set to 0
    CLRF level 
    CLRF AorD    
    CLRF d_leds
    CLRF blinker_flag
    CLRF re4_state
    CLRF ra4_state
        ; set RA4 as input source, clear PORTA LEDs
    movlw 00010000B     ; move literal written as a binary value to W 
    movwf TRISA         ; move W to TRISA to indicate input/output direction 
                        ; only RA4 pin is input
    clrf  LATA          ; clear output latch so that all LEDs in PORTA is turned off
        ; set RE4 as input source, clear PORTE LEDs
    movlw 00010000B     ; move literal written as a binary value to W 
    movwf TRISE         ; move W to TRISA to indicate input/output direction 
                        ; only RA4 pin is input
    clrf  LATE          ; clear output latch so that all LEDs in PORTE is turned off
    ; initialize PORTB as output source
    movlw 0x00          ; move literal written as a hexadecimal value to W
    movwf TRISB         ; move W to TRISB to indicate input/output direction 
                        ; all pins are outputs
    ; light_portb_leds
    movlw 0x0F          
    movwf LATB          ; move W to LATB to light all leds of RB[0-3]
    ; initialize PORTC as output source
    movlw 0x00          ; move literal written as a hexadecimal value to W
    movwf TRISC         ; move W to TRISC to indicate input/output direction 
                        ; all pins are outputs
    ; light_portc_leds
    movlw 00000011B          
    movwf LATC          ; move W to LATC to light all leds of RC[0-1] 
    ; initialize PORTD as output source
    movlw 0x00          ; move literal written as a hexadecimal value to W
    movwf TRISD         ; move W to TRISD to indicate input/output direction 
                        ; all pins are outputs
    ; light_portb_leds
    movlw 0xFF          ; move all 1's to W
    movwf LATD          ; move W to LATD to light all leds
    
    //call busy_delay_1sec
    
    return
 
busy_delay_500msec:
    nop
    movlw 0x42      ; copy desired value to W
    movwf _m3       ; copy W into t3
    _loop33:
        movlw 0xAF      ; copy desired value to W
        movwf _m2       ; copy W into t2
        _loop22:
            movlw 0x8F      ; copy desired value to W
            movwf _m1       ; copy W into t1
            _loop11:
                decfsz _m1, 1   ; decrement t1, if 0 skip next 
                goto _loop11     ; else keep counting down
                decfsz _m2, 1   ; decrement t2, if 0 skip next 
                goto _loop22     ; else keep counting down
                decfsz _m3, 1   ; decrement t3, if 0 skip next 
                goto _loop33     ; else keep counting down
                return 
    
  
busy_delay_1sec:
    movlw 0x84      ; copy desired value to W
    movwf _t3       ; copy W into t3
    _loop3:
        movlw 0xAF      ; copy desired value to W
        movwf _t2       ; copy W into t2
        _loop2:
            movlw 0x8F      ; copy desired value to W
            movwf _t1       ; copy W into t1
            _loop1:
                decfsz _t1, 1   ; decrement t1, if 0 skip next 
                goto _loop1     ; else keep counting down
                decfsz _t2, 1   ; decrement t2, if 0 skip next 
                goto _loop2     ; else keep counting down
                decfsz _t3, 1   ; decrement t3, if 0 skip next 
                goto _loop3     ; else keep counting down
                return    
    
default_state:
    CLRF flag_num      ; initially, flag is set to 0
    CLRF bflag_num     ; flag for Port B is set to 0
    CLRF cflag         ; flag for Port C is set to 0
    CLRF level		
    CLRF AorD    
    CLRF d_leds
    CLRF blinker_flag
    INCF blinker_flag	    ; set blinker flag to 1 (on at first)
    
    ; variables for 500ms non-busy wait
    MOVLW 0X99		    
    MOVWF D1
    MOVLW 0X99
    MOVWF D2
    MOVLW 0X04
    MOVWF D3
    
    movlw 0x00          ; move all 0's to W
    movwf LATD          ; Light off all leds on D
    movlw 0x01          
    movwf LATB          ;Light off all leds except first on B
    movlw 0x01          
    movwf LATC          ;Light off all leds except first on C
    return
 

    
    
    
update_flag:  ;Flag to keep track of the PORT
    incf flag_num	;increment flag number ( 1 - Port B , 2 - Port C , 3 - Port D)
    return
    
update_portb_flag:
    incf bflag_num	;increment flag number ( 0 - Level 1 , 1 - Level 2 , 2 - Level 3, 3 - Level 4)
    movlw 0x04          ; move 4 to W
    ;; CPFSEQ: compare register f with W, skip next instruction if they are equal
    cpfseq bflag_num		; compare flag_num  with W
    return
    goto reset_LED_PORTB        ; Reset to default on PortB
   
    reset_LED_PORTB:        ; Reset to default on PortB
	clrf bflag_num      ; clear flag of PortB to 0
	movlw 0x01          
	movwf LATB          ;Light off all leds except first on B
	return
    
	
	
update_portc_flag:
    ;; cflag: ( 0 - Attack , 1 - Defend)
    movlw 0x00          ; move 0 to W
    ;; CPFSEQ: compare register f with W, skip next instruction if they are equal
    cpfseq cflag	; compare flag_num  with W
    goto clear_portc	; If it was Attack (0), go to Defend(1)
    goto set_portc      ; If it was Defend(1), go to Attack(0)

    set_portc:
	movlw 00000001B          
	movwf cflag        ; Set flag of PortC to 1
	return
	
    clear_portc:
	CLRF cflag          ; Set flag of PortC to 0
	return
    
    
button_task_re4:
    btfsc PORTE, 4          ; if re4 is currently not pressed, return
    goto wait_re4_release   ; if pressed, wait until released
    return
    
    wait_re4_release:
        btfsc PORTE, 4          ; if re4 is not released
        goto wait_re4_release   ; wait until it is released (else skip here)
        call update_flag        ; change flag_num to show the Port-X
	call Reset_lights	; Reset the Blinking state to normal state of previous Port
	CLRF blinker_flag	
	INCF blinker_flag	; Set blinker_flag to 1
	return
 
button_task_ra4:
    btfsc PORTA, 4          ; if ra4 is currently not pressed, return
    goto wait_ra4_release   ; if pressed, wait until released
    return

    wait_ra4_release:
        btfsc PORTA, 4          ; if ra4 is not released
        goto wait_ra4_release   ; wait until it is released (else skip here)
	
	movlw 0x01          ; move 1 to W
	cpfseq flag_num     ; compare flag_num  with W
	goto portc_flag
        call update_portb_flag  ; change flag_num to show the Port-B's value
	return
	
	portc_flag:
	movlw 0x02          ; move 2 to W
	cpfseq flag_num     ; compare flag_num  with W
	return
	call update_portc_flag  ; change flag_num to show the Port-C's value
	return
	
portD_trigger:
    movf bflag_num,w	    
    movwf level
    incf level		    ; level variable now contains the levels on PortB
    
    movf cflag, w
    movwf AorD
    incf AorD               ; AorD contains either 1 for Defense or 0 for Attack

    looper_AorD:	    ; d_leds = level * AorD
	movf level,w
	addwf d_leds
	decfsz AorD, 1
	goto looper_AorD
    
    ; if d_leds == X, open all X and then close 1 by 1 with 500ms intervals
    case_8_leds:	
	movlw 0x08      
	cpfseq d_leds    
	goto case_6_leds
	movlw 11111111B
	movwf LATD
	call busy_delay_500msec
	movlw 01111111B
	movwf LATD
	call busy_delay_500msec
	movlw 00111111B
	movwf LATD
	call busy_delay_500msec
	movlw 00011111B
	movwf LATD
	call busy_delay_500msec
	movlw 00001111B
	movwf LATD
	call busy_delay_500msec
	movlw 00000111B
	movwf LATD
	call busy_delay_500msec
	movlw 00000011B
	movwf LATD
	call busy_delay_500msec
	movlw 00000001B
	movwf LATD
	call busy_delay_500msec
	movlw 00000000B
	movwf LATD 
	return
	
    case_6_leds:
	movlw 0x06        
	cpfseq d_leds     
	goto case_4_leds
	movlw 00111111B
	movwf LATD
	call busy_delay_500msec
	movlw 00011111B
	movwf LATD
	call busy_delay_500msec
	movlw 00001111B
	movwf LATD
	call busy_delay_500msec
	movlw 00000111B
	movwf LATD
	call busy_delay_500msec
	movlw 00000011B
	movwf LATD
	call busy_delay_500msec
	movlw 00000001B
	movwf LATD
	call busy_delay_500msec
	movlw 00000000B
	movwf LATD 
	return    

    
    case_4_leds:
	movlw 0x04      
	cpfseq d_leds    
	goto case_3_leds
	movlw 00001111B
	movwf LATD
	call busy_delay_500msec
	movlw 00000111B
	movwf LATD
	call busy_delay_500msec
	movlw 00000011B
	movwf LATD
	call busy_delay_500msec
	movlw 00000001B
	movwf LATD
	call busy_delay_500msec
	movlw 00000000B
	movwf LATD 
	return

    case_3_leds:
	movlw 0x03        
	cpfseq d_leds    
	goto case_2_leds
	movlw 00000111B
	movwf LATD
	call busy_delay_500msec
	movlw 00000011B
	movwf LATD
	call busy_delay_500msec
	movlw 00000001B
	movwf LATD
	call busy_delay_500msec
	movlw 00000000B
	movwf LATD 
	return

    case_2_leds:
	movlw 0x02       
	cpfseq d_leds    
	goto case_1_leds
	movlw 00000011B
	movwf LATD
	call busy_delay_500msec
	movlw 00000001B
	movwf LATD
	call busy_delay_500msec
	movlw 00000000B
	movwf LATD 
	return
	
    case_1_leds:
	movlw 00000001B
	movwf LATD
	call busy_delay_500msec
	movlw 00000000B
	movwf LATD 
	return

	

blinker_off:  ;TURN OFF THE LIGHTS IN BLINK STATE
    CLRF blinker_flag
    movlw 0x00          
    cpfseq flag_num     ; Port_flag != 0 --> TURN OFF
    Goto Should_off
    return		; Else return
    
    Should_off:		; TURN OFF
	
	movlw 0x01          ; move 1 to W
	cpfseq flag_num     ; compare flag_num  with W
	goto C_OFF	    ; Port C selected?
	goto B_OFF          ; Port B selected?

    C_OFF:
	movlw 0x00          
	movwf LATC          ;Light off all leds
	return
    
    B_OFF:
    	movlw 0x00          
	movwf LATB          ;Light off all leds
	return
    
	
blinker_on:     ;TURN ON THE LIGHTS IN BLINK STATE
    SETF blinker_flag
    movlw 0x00          
    cpfseq flag_num     ; Port_flag != 0 --> TURN ON
    Goto Should_ON
    return

    Should_ON:              ; TURN ON
	movlw 0x01          
	cpfseq flag_num     
	goto C_ON           ; Port C selected?
	goto B_ON           ; Port B selected?
 
    C_ON:             ; Port C selected!
	movlw 0x00          
	cpfseq cflag    
	goto C_D1	  ;Turn on Attack(LED 0) if cflag was 0

	C_A0:                   ;Turn on Attack(LED 0) if cflag was 0
	    movlw 00000001B          
	    movwf LATC          ;Light off all leds except first
	    return

	C_D1:                   ;Turn on Attack(LED 0) if cflag was not 0
	    movlw 00000010B           
	    movwf LATC          ;Light off all leds except second
	    return

    B_ON:            ; Port B selected!
	movlw 0x00         
	cpfseq bflag_num    ; compare bflag_num  with 0
	goto B_L2	    ; If not 0 then go check if bflag was 1
	movlw 00000001B	    ; If bflag was 0, Turn on LED 1
	movwf LATB
	return

	B_L2:
	    movlw 0x01          ; move 1 to W
	    cpfseq bflag_num    ; compare flag_num  with 1
	    goto B_L3           ; If not 1 then go check if bflag was 2
	    movlw 00000011B     ; If bflag was 1, Turn on LED 1,2
	    movwf LATB
	    return	
	B_L3:
	    movlw 0x02          ; move 2 to W
	    cpfseq bflag_num    ; compare flag_num  with 2
	    goto B_L4           ; If not 2 then bflag was 3
	    movlw 00000111B     ; If bflag was 2, Turn on LED 1,2,3
	    movwf LATB
	    return	
	B_L4:
	    movlw 00001111B      ; else bflag was 3, Turn on LED 1,2,3,4
	    movwf LATB
	    return


Reset_lights:        ;When going to next Port, Reset blinking state of last Port to Normal
    
	movlw 0x03          ; move 3 to W
	cpfseq flag_num     ; compare flag_num  with 3
	goto Norm
	goto C1_ON
    
    Norm:
	movlw 0x01          ; move 1 to W
	cpfseq flag_num     ; compare flag_num  with W
	goto B1_ON	    ; Last port was B
	goto C1_ON	    ; Last port was C

    C1_ON:
	movlw 0x00         
	cpfseq cflag        
	goto C1_D1

	C1_A0:
	    movlw 00000001B          
	    movwf LATC          ;Light off all leds except first
	    return

	C1_D1:
	    movlw 00000010B          
	    movwf LATC          ;Light off all leds except second
	    return

    B1_ON:
	movlw 0x00          ; move 0 to W
	cpfseq bflag_num    ; compare flag_num  with W
	goto B1_L2
	movlw 00000001B
	movwf LATB
	return

	B1_L2:
	    movlw 0x01          ; move 1 to W
	    cpfseq bflag_num    ; compare flag_num  with 1
	    goto B1_L3          ; If not 1 then go check if bflag was 2
	    movlw 00000011B     ; If bflag was 1, Turn on LED 1,2
	    movwf LATB
	    return	
	B1_L3:
	    movlw 0x02          ; move 2 to W
	    cpfseq bflag_num    ; compare flag_num  with 2
	    goto B1_L4          ; If not 2 then bflag was 3
	    movlw 00000111B     ; If bflag was 2, Turn on LED 1,2,3
	    movwf LATB
	    return	
	B1_L4:
	    movlw 00001111B      ; else bflag was 3, Turn on LED 1,2,3,4
	    movwf LATB
	    return
	    
	    
; DO NOT DELETE OR MODIFY
; 500ms pass check for test scripts
ms500_passed:
    nop
    return
  	
; DO NOT DELETE OR MODIFY
; 1sec pass check for test scripts
ms1000_passed:
    nop
    return
	
PSECT CODE
main:
    call initialise           ;Initialise Ports/Variables/IO
    call busy_delay_1sec      ;Wait 1 second
    call default_state	      ;GOTO Default State
    nop				
    loop:

	check_press_re4:

	    ;; if RE4 button pressed, change RE4 state to 1
	    btfsc PORTE, 4          
	    SETF re4_state          
	    btfsc re4_state, 0	
	    goto wait_re4_release1	;;if state is 1, go to wait release
	    goto continue_after_re4   ;;if state is 0, continue and ignore 

	wait_re4_release1:
	    btfsc PORTE, 4          ;; if RE4 button not released, continue and ignore
	    goto continue_after_re4
	    ;;else
	    CLRF re4_state		;;clear re4_state back to 0    
	    call update_flag        ;;Do the functionality of the RE4 button
	    call Reset_lights	; Reset the Blinking state to normal state of previous Port
	    CLRF blinker_flag	
	    INCF blinker_flag	; Set blinker_flag to 1

	continue_after_re4:

	    movlw 0x03		
	    cpfseq flag_num		; compare flag_num of Ports with 3(PORT D)
	    goto Continue
	    goto portD_caller	; If flag == 3, trigger port D

    Continue:	
        check_press_ra4:
	    ;; if RA4 button pressed, change RA4 state to 1
	    btfsc PORTA, 4          
	    SETF ra4_state          
	    btfsc ra4_state, 0	
	    goto wait_RA4_release1	;;if state is 1, go to wait release
	    goto delayer_and_blinker    ;;if state is 0, continue and ignore 
	    
	wait_RA4_release1:
	    btfsc PORTA, 4          ;; if RA4 button not released, continue and ignore
	    goto delayer_and_blinker
	    ;;else
	    CLRF ra4_state		;;clear RA4_state back to 0 
	    
	    movlw 0x01          ; move 1 to W
	    cpfseq flag_num     ; compare flag_num  with W
	    goto portc_call
	    call update_portb_flag  ; change flag_num to show the Port-B's value
	    goto delayer_and_blinker 

	    portc_call:
	    movlw 0x02          ; move 2 to W
	    cpfseq flag_num     ; compare flag_num  with W
	    goto delayer_and_blinker
	    call update_portc_flag  ; change flag_num to show the Port-C's value
	    
	    
	delayer_and_blinker:
	    ;;500ms round robin non-busy wait
	    DECFSZ D1, 1		
	    GOTO loop
	    DECFSZ D2, 1
	    GOTO loop
	    DECFSZ D3, 1
	    GOTO loop
	
	    ;;Check last blinking state(ON or OFF) and change it
	    MOVLW 0X00
	    CPFSEQ blinker_flag
	    goto blink_off_call
	    goto blink_on_call

	blink_off_call: 
	    call blinker_off
	    goto cont
 
	blink_on_call:
	    call blinker_on
	    goto cont

    cont:
    
	;;Reset time delay variables
	MOVLW 0X99
	MOVWF D1
	MOVLW 0X99
	MOVWF D2
	MOVLW 0X04
	MOVWF D3
	goto loop
	
    portD_caller:	    ;;If Port D is triggered comes here
	call portD_trigger  ;;Call function
	call default_state  ;;Reset to default state after round finished
	goto loop	    

    
	
    //
    //call ms1000_passed
    ; a loop here, maybe
    //loop:
        ; inside the loop, once it is confirmed 500ms passed
        //call ms500_passed
        //goto loop

end resetVec