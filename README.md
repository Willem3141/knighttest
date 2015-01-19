# knighttest
A quick-and-dirty unit test runner for KnightOS. This still is heavy work in progress.

## Writing tests
To add tests, edit the file `tests.asm`. Create a function that performs the test, like this:

````
testSomething:
    ; perform the test
    
    ; if passed:
    kcall(pass)
    ; if failed:
    kcall(fail)
    
    ret
````

Then in the test table at the top of the file, insert the name of your test, and increment the number:

````
tests:
    .db 2 ; number of tests    ; <- incremented
    .dw testTrivial
    .dw testSomething          ; <- added
````

Now recompile the test runner and run it.
