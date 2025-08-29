        .org $0800          ; Start program at $0800
        .segment "CODE"

; Constants
SLOT4_BASE = $C400          ; Base address for Mockingboard in Slot 4
VIA_T1CL   = SLOT4_BASE+$04 ; Timer 1 Counter Low
VIA_T1CH   = SLOT4_BASE+$05 ; Timer 1 Counter High
VIA_ACR    = SLOT4_BASE+$0B ; Auxiliary Control Register
VIA_IER    = SLOT4_BASE+$0E ; Interrupt Enable Register
VIA_IFR    = SLOT4_BASE+$0D ; Interrupt Flag Register

SCREEN_BASE = $400          ; Text screen memory base (top-left corner)

START:
        SEI                 ; Disable interrupts during setup

        ; Enable writable RAM over ROM (language card setup)
        LDA $C081           ; Switch writable RAM over ROM
        LDA $C081           ; Repeat for stability

        LDA $C083
        LDA $C083

        ; Redirect IRQ/BRK vector to custom handler in RAM
        LDA #<ISR           ; Low byte of ISR address
        STA $FFFE           ; Store at IRQ vector low byte
        LDA #>ISR           ; High byte of ISR address
        STA $FFFF           ; Store at IRQ vector high byte

        ; Initialize Mockingboard VIA Timer
        LDA #$40            ; Set T1 to continuous mode (bit 6)
        STA VIA_ACR         ; Write to Auxiliary Control Register

        LDA #$FF            ; Set Timer 1 low byte (frequency divisor)
        STA VIA_T1CL
        LDA #$FF            ; Set Timer 1 high byte (frequency divisor)
        STA VIA_T1CH

        LDA VIA_T1CL        ; Clear Timer 1 Interrupt Flag

        LDA #$C0            ; Enable Timer 1 interrupt (bit 7 + bit 6)
        STA VIA_IER         ; Write to Interrupt Enable Register

        CLI                 ; Enable interrupts

MAIN_LOOP:
        JMP MAIN_LOOP       ; Infinite loop (interrupts handle updates)

; Interrupt Service Routine (ISR)
;ISR:
;        PHA                 ; preserve A (add TXA/PHX/PHY if you use X/Y)
;        LDA VIA_T1CL        ; ack T1 (clears flag)
;
;        INC COUNTER
;        LDA COUNTER
;        CLC
;        ADC #$30
;        STA SCREEN_BASE
;
;        PLA
;        RTI

ISR:
        PHA
        LDA VIA_T1CL        ; ack T1

        INC TICK
        LDA TICK
        AND #$0F            ; every 16th tick (~1.0 s)
        BNE SKIP

        INC COUNTER
        LDA COUNTER
        AND #$0F            ; keep it readable 0..15
        CLC
        ADC #$30
        STA SCREEN_BASE

SKIP:
        PLA
        RTI

TICK:
.byte 0

COUNTER:
.byte 0
