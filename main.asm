#include "kernel.inc"
#include "corelib.inc"
    .db "KEXC"
    .db KEXC_ENTRY_POINT
    .dw start
    .db KEXC_STACK_SIZE
    .dw 20
    .db KEXC_NAME
    .dw program_name
    .db KEXC_HEADER_END
program_name:
    .db "KnightOS test runner", 0
start:
    
    ; load dependencies
    kld(de, corelibPath)
    pcall(loadLibrary)
    
    ; get a lock on the devices we intend to use
    pcall(getLcdLock)
    pcall(getKeypadLock)
    
    ; allocate and clear a buffer to store the contents of the screen
    pcall(allocScreenBuffer)
    
    ; start running tests
.testLoop:
    ; increase test_id
    kld(a, (test_id))
    inc a
    kld((test_id), a)
    
    ; check whether we are done
    kld(a, (tests))
    ld b, a
    kld(a, (test_id))
    cp b
    kjp(z, .ready)
    
    ; draw the GUI
    pcall(clearBuffer)
    kld(hl, program_name)
    xor a
    corelib(drawWindow)
    
    kld(hl, running_test_str)
    ld de, 0x0208
    pcall(drawStr)
    kld(a, (test_id))
    inc a
    pcall(drawDecA)
    ld a, '/'
    pcall(drawChar)
    kld(a, (tests))
    pcall(drawDecA)
    
    ld de, 0x020f
    kld(a, (num_passed))
    pcall(drawDecA)
    kld(hl, tests_passed_str)
    pcall(drawStr)
    
    ld de, 0x0215
    kld(a, (num_failed))
    pcall(drawDecA)
    kld(hl, tests_failed_str)
    pcall(drawStr)
    
    pcall(fastCopy)

    ; put the address of the test in hl
    kld(a, (test_id))
    ld l, a
    ld h, 0
    add hl, hl

    kld(de, tests)
    add hl, de

    inc hl

    ; put return address on the stack
    kld(hl, .testLoop)
    push hl
        ; preserve iy, so that even if the test destroys it, we
        ; don't lose our screen buffer
        push iy
              ; call the test
              kld(hl, tests)
              inc hl
              kld(a, (test_id))
              add a, a
              ld e, a
              ld d, 0
              add hl, de
              
              ld a, (hl)
              ld e, a
              inc hl
              ld a, (hl)
              ld d, a
              pcall(getCurrentThreadID)
              pcall(getEntryPoint)
              add hl, de
              jp (hl)

.ready:
    ; draw the GUI
    pcall(clearBuffer)
    kld(hl, program_name)
    xor a
    corelib(drawWindow)
    
    kld(hl, done_str)
    ld de, 0x0208
    pcall(drawStr)
    
    ld de, 0x020f
    kld(a, (num_passed))
    pcall(drawDecA)
    kld(hl, tests_passed_str)
    pcall(drawStr)
    
    ld de, 0x0215
    kld(a, (num_failed))
    pcall(drawDecA)
    kld(hl, tests_failed_str)
    pcall(drawStr)
    
    pcall(fastCopy)
    
    pcall(flushKeys)
    
    pcall(waitKey)
    
    cp kMODE
    jr nz, .ready
    
    ret

pass:
    kld(a, (num_passed))
    inc a
    kld((num_passed), a)
    pop iy
    ret

fail:
    kld(a, (num_failed))
    inc a
    kld((num_failed), a)
    pop iy
    ret

popOnceAndFail:
    pop hl
    jr fail

popTwiceAndFail:
    pop hl
    pop hl
    jr fail

printDebugAndHalt:
    ; restore pointer to display buffer
    pop iy \ pop iy

    ; values
    ld a, b
    ld de, 0x1822
    pcall(drawHexA)
    ld a, c
    ld de, 0x2222
    pcall(drawHexA)
    ld a, d
    push de
        ld de, 0x4822
        pcall(drawHexA)
    pop de
    ld a, e
    push de
        ld de, 0x5222
        pcall(drawHexA)
    pop de
    ld a, h
    ld de, 0x1828
    pcall(drawHexA)
    ld a, l
    ld de, 0x2228
    pcall(drawHexA)
    push ix \ pop hl
    ld a, h
    ld de, 0x4828
    pcall(drawHexA)
    ld a, l
    ld de, 0x5228
    pcall(drawHexA)

    ; labels
    ld de, 0x0a22
    ld a, 'b'
    pcall(drawChar)
    ld a, 'c'
    pcall(drawChar)
    ld a, ':'
    pcall(drawChar)
    ld de, 0x3a22
    ld a, 'd'
    pcall(drawChar)
    ld a, 'e'
    pcall(drawChar)
    ld a, ':'
    pcall(drawChar)
    ld de, 0x0a28
    ld a, 'h'
    pcall(drawChar)
    ld a, 'l'
    pcall(drawChar)
    ld a, ':'
    pcall(drawChar)
    ld de, 0x3a28
    ld a, 'i'
    pcall(drawChar)
    ld a, 'x'
    pcall(drawChar)
    ld a, ':'
    pcall(drawChar)

    pcall(fastCopy)
    jr $

; variables
test_id:
    .db -1

num_passed:
    .db 0

num_failed:
    .db 0

; constants
corelibPath:
    .db "/lib/core", 0
running_test_str:
    .db "Running test ", 0
tests_passed_str:
    .db " tests passed", 0
tests_failed_str:
    .db " tests failed", 0
failed_test_str:
    .db "Failed test: ", 0
press_enter_str:
    .db "Press Enter to continue...", 0
done_str:
    .db "Done!", 0

#include "macros.inc"
#include "tests.asm"
