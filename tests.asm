tests:
    .db 5 ; number of tests
    .dw testTrivial
    .dw testConvertTimeFromTicks1
    .dw testConvertTimeFromTicks2
    .dw testConvertTimeFromTicks3
    .dw testConvertTimeFromTicks4

; basic test that always passes
testTrivial:
    kjp(pass)

; tests convertTimeFromTicks with timestamp 0
; (1997-01-01 00:00:00)
testConvertTimeFromTicks1:
    ld hl, 0
    ld de, 0
    pcall(convertTimeFromTicks)
    
    assertIXEqualTo(1997)  ; year
    assertLEqualTo(0)      ; month
    assertHEqualTo(0)      ; day
    
    assertBEqualTo(0)      ; hour
    assertCEqualTo(0)      ; minute
    assertDEqualTo(0)      ; second
    
    assertAEqualTo(3)      ; day of week
    
    kjp(pass)

; tests convertTimeFromTicks with timestamp 86,400
; (1997-01-02 00:00:00)
testConvertTimeFromTicks2:
    ld hl, 86400 & 0xffff
    ld de, 86400 >> 16
    pcall(convertTimeFromTicks)
    
    assertIXEqualTo(1997)  ; year
    assertLEqualTo(0)      ; month
    assertHEqualTo(1)      ; day
    
    assertBEqualTo(0)     ; hour
    assertCEqualTo(0)     ; minute
    assertDEqualTo(0)     ; second
    
    assertAEqualTo(4)      ; day of week
    
    kjp(pass)

; tests convertTimeFromTicks with timestamp 31,536,000
; (1998-01-01 00:00:00)
testConvertTimeFromTicks3:
    ld hl, 31536000 & 0xffff
    ld de, 31536000 >> 16
    pcall(convertTimeFromTicks)
    
    assertIXEqualTo(1998)  ; year
    assertLEqualTo(0)      ; month
    assertHEqualTo(0)      ; day
    
    assertBEqualTo(0)     ; hour
    assertCEqualTo(0)     ; minute
    assertDEqualTo(0)     ; second
    
    assertAEqualTo(4)      ; day of week
    
    kjp(pass)

; tests convertTimeFromTicks with timestamp 569,685,536
; (2015-01-20 13:58:56)
testConvertTimeFromTicks4:
    ld hl, 569685536 & 0xffff
    ld de, 569685536 >> 16
    pcall(convertTimeFromTicks)
    
    assertIXEqualTo(2015)  ; year
    assertLEqualTo(0)      ; month
    assertHEqualTo(20)      ; day
    
    assertBEqualTo(13)     ; hour
    assertCEqualTo(58)     ; minute
    assertDEqualTo(56)     ; second
    
    assertAEqualTo(2)      ; day of week
    
    kjp(pass)
