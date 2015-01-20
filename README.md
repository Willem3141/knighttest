# knighttest
A quick-and-dirty unit test runner for KnightOS. This still is heavy work in progress.

## Writing tests
To add tests, edit the file `tests.asm`. Create a function that performs the test, like this:

````
testSomething:
    ; perform the test
    
    ; if passed:
    kjp(pass)
    ; if failed:
    kjp(fail)
````

Then in the test table at the top of the file, insert the name of your test, and increment the number:

````
tests:
    .db 2 ; number of tests    ; <- incremented
    .dw testTrivial
    .dw testSomething          ; <- added
````

Now recompile the test runner and run it.

## Macros
The test runner provides several macros that can be used to write tests more easily.

| Macro                       | Description                                     |
| --------------------------- | ----------------------------------------------- |
| `assertAEqualTo(expected)`  | Fails if `a` doesn't match the expected value.  |
| `assertBEqualTo(expected)`  | Fails if `b` doesn't match the expected value.  |
| `assertCEqualTo(expected)`  | Fails if `c` doesn't match the expected value.  |
| `assertDEqualTo(expected)`  | Fails if `d` doesn't match the expected value.  |
| `assertEEqualTo(expected)`  | Fails if `e` doesn't match the expected value.  |
| `assertHEqualTo(expected)`  | Fails if `h` doesn't match the expected value.  |
| `assertLEqualTo(expected)`  | Fails if `l` doesn't match the expected value.  |
| `assertBCEqualTo(expected)` | Fails if `bc` doesn't match the expected value. |
| `assertDEEqualTo(expected)` | Fails if `de` doesn't match the expected value. |
| `assertHLEqualTo(expected)` | Fails if `hl` doesn't match the expected value. |
| `assertIXEqualTo(expected)` | Fails if `ix` doesn't match the expected value. |
