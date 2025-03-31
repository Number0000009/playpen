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

        ; Copy ROM contents into RAM at $F800-$FFFF
        LDY #$00            ; Initialize index register
COPY_LOOP:
        LDA $F800,Y         ; Load byte from ROM
        STA $F800,Y         ; Store byte into RAM
        INY                 ; Increment index
        CPY #$80            ; Check if done (256 bytes per page)
        BNE COPY_LOOP       ; Repeat until done

        LDA $C083
        LDA $C083

        ; Redirect IRQ/BRK vector to custom handler in RAM
        LDA #<ISR           ; Low byte of ISR address
        STA $FFFE           ; Store at IRQ vector low byte
        LDA #>ISR           ; High byte of ISR address
        STA $FFFF           ; Store at IRQ vector high byte

;        CLI                 ; Enable interrupts

        ; Initialize Mockingboard VIA Timer
        LDA #$40            ; Set T1 to continuous mode (bit 6)
        STA VIA_ACR         ; Write to Auxiliary Control Register

        LDA #$FF            ; Set Timer 1 high byte (frequency divisor)
        STA VIA_T1CH

        LDA #$00            ; Set Timer 1 low byte (frequency divisor)
        STA VIA_T1CL

        LDA #$82            ; Enable Timer 1 interrupt (bit 7 + bit 1)
        STA VIA_IER         ; Write to Interrupt Enable Register

        CLI
MAIN_LOOP:
        JMP MAIN_LOOP       ; Infinite loop (interrupts handle updates)

; Interrupt Service Routine (ISR)
ISR:
        SEI
        INC COUNTER         ; Increment counter

        LDA COUNTER         ; Load counter value into A
        CLC                 ; Convert binary to ASCII
        ADC #$30            ; Add ASCII '0'

CHECK_ZERO:
        STA SCREEN_BASE     ; Display it at top left.
        CLI
        RTI

COUNTER:
.byte $00
