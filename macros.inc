.macro assertAEqualTo(expected)
    cp expected
    kjp(nz, fail)
.endmacro

.macro assertBEqualTo(expected)
    push af
        ld a, b
        cp expected
        kjp(nz, popOnceAndFail)
    pop af
.endmacro

.macro assertCEqualTo(expected)
    push af
        ld a, c
        cp expected
        kjp(nz, popOnceAndFail)
    pop af
.endmacro

.macro assertDEqualTo(expected)
    push af
        ld a, d
        cp expected
        kjp(nz, popOnceAndFail)
    pop af
.endmacro

.macro assertEEqualTo(expected)
    push af
        ld a, e
        cp expected
        kjp(nz, popOnceAndFail)
    pop af
.endmacro

.macro assertHEqualTo(expected)
    push af
        ld a, h
        cp expected
        kjp(nz, popOnceAndFail)
    pop af
.endmacro

.macro assertLEqualTo(expected)
    push af
        ld a, l
        cp expected
        kjp(nz, popOnceAndFail)
    pop af
.endmacro

.macro assertBCEqualTo(expected)
    push af
        ld a, b
        cp (expected) >> 8
        kjp(nz, popOnceAndFail)
        ld a, c
        cp (expected) & 0x00ff
        kjp(nz, popOnceAndFail)
    pop af
.endmacro

.macro assertDEEqualTo(expected)
    push af
        ld a, d
        cp (expected) >> 8
        kjp(nz, popOnceAndFail)
        ld a, e
        cp (expected) & 0x00ff
        kjp(nz, popOnceAndFail)
    pop af
.endmacro

.macro assertHLEqualTo(expected)
    push af
        ld a, h
        cp (expected) >> 8
        kjp(nz, popOnceAndFail)
        ld a, l
        cp (expected) & 0x00ff
        kjp(nz, popOnceAndFail)
    pop af
.endmacro

.macro assertIXEqualTo(expected)
    push af \ push de
        push ix \ pop de
        ld a, d
        cp (expected) >> 8
        kjp(nz, popTwiceAndFail)
        ld a, e
        cp (expected) & 0x00ff
        kjp(nz, popTwiceAndFail)
    pop de \ pop af
.endmacro
