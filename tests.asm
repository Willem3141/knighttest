tests:
    .db 1 ; number of tests
    .dw testTrivial

; basic test that always passes
testTrivial:
    kjp(pass)
