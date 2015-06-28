tests:
    .db 38 ; number of tests
    .dw testTrivial
    .dw testIsLeapYear
    .dw testMonthLength
    .dw testConvertTimeToTicks1
    .dw testConvertTimeToTicks2
    .dw testConvertTimeToTicks3
    .dw testConvertTimeToTicks4
    .dw testConvertTimeToTicks5
    .dw testConvertTimeToTicks6
    .dw testConvertTimeToTicks7
    .dw testConvertTimeToTicks8
    .dw testConvertTimeToTicks9
    .dw testConvertTimeToTicks10
    .dw testConvertTimeToTicks11
    .dw testConvertTimeToTicks12
    .dw testConvertTimeToTicks13
    .dw testConvertTimeToTicks14
    .dw testConvertTimeToTicks15
    .dw testConvertTimeToTicks16
    .dw testConvertTimeToTicks17
    .dw testConvertTimeToTicks18
    .dw testConvertTimeToTicks19
    .dw testConvertTimeToTicks20
    .dw testConvertTimeToTicks21
    .dw testConvertTimeToTicks22
    .dw testConvertTimeToTicks23
    .dw testConvertTimeToTicks24
    .dw testConvertTimeToTicks25
    .dw testConvertTimeToTicks26
    .dw testConvertTimeToTicks27
    .dw testConvertTimeToTicks28
    .dw testConvertTimeToTicks29
    .dw testConvertTimeToTicks30
    .dw testConvertTimeToTicks31
    .dw testConvertTimeToTicks32
    .dw testConvertTimeToTicks33
    .dw testConvertTimeToTicks34
    .dw testConvertTimeToTicks35

; basic test that always passes
testTrivial:
    kjp(pass)

; tests isLeapYear
testIsLeapYear:
    
    ; normal leap year
    ld hl, 2012
    pcall(isLeapYear)
    assertAEqualTo(1)
    
    ; normal non-leap year
    ld hl, 2013
    pcall(isLeapYear)
    assertAEqualTo(0)
    
    ; non-leap year (divisible by 100)
    ld hl, 2100
    pcall(isLeapYear)
    assertAEqualTo(0)
    
    ; non-leap year (divisible by 100)
    ld hl, 1900
    pcall(isLeapYear)
    assertAEqualTo(0)
    
    ; leap year (divisible by 400)
    ld hl, 2000
    pcall(isLeapYear)
    assertAEqualTo(1)
    
    ; leap year (divisible by 400)
    ld hl, 2400
    pcall(isLeapYear)
    assertAEqualTo(1)
    
    kjp(pass)

; tests monthLength
testMonthLength:
    ld hl, 2015
    ld e, 0
    pcall(monthLength)
    assertAEqualTo(31)
    
    ld hl, 2015
    ld e, 3
    pcall(monthLength)
    assertAEqualTo(30)
    
    ld hl, 2015 ; non-leap year
    ld e, 1
    pcall(monthLength)
    assertAEqualTo(28)
    
    ld hl, 2016 ; leap year
    ld e, 1
    pcall(monthLength)
    assertAEqualTo(29)
    
    kjp(pass)

.macro createConvertToTicksTest(name, year, month, day, hour, minute, second, ticks)
    name:
        ld ix, year
        ld l, (month) - 1
        ld h, (day) - 1
        
        ld b, hour
        ld c, minute
        ld d, second
        
        pcall(convertTimeToTicks)
        
        assertHLEqualTo((ticks) & 0xffff)
        assertDEEqualTo((ticks) >> 16)
        
        ld hl, (ticks) & 0xffff
        ld de, (ticks) >> 16
        
        pcall(convertTimeFromTicks)
        
        assertIXEqualTo(year)
        assertLEqualTo((month) - 1)
        assertHEqualTo((day) - 1)
        
        assertBEqualTo(hour)
        assertCEqualTo(minute)
        assertDEqualTo(second)
        
        kjp(pass)
.endmacro

; first day of years
createConvertToTicksTest(testConvertTimeToTicks1, 1998, 01, 01, 00, 00, 00, 31536000)
createConvertToTicksTest(testConvertTimeToTicks2, 1999, 01, 01, 00, 00, 00, 63072000)
createConvertToTicksTest(testConvertTimeToTicks3, 2000, 01, 01, 00, 00, 00, 94608000)
createConvertToTicksTest(testConvertTimeToTicks4, 2001, 01, 01, 00, 00, 00, 126230400)
createConvertToTicksTest(testConvertTimeToTicks5, 2002, 01, 01, 00, 00, 00, 157766400)

; first day of every month in a non-leap year
createConvertToTicksTest(testConvertTimeToTicks6, 2015, 01, 01, 00, 00, 00, 567993600)
createConvertToTicksTest(testConvertTimeToTicks7, 2015, 02, 01, 00, 00, 00, 570672000)
createConvertToTicksTest(testConvertTimeToTicks8, 2015, 03, 01, 00, 00, 00, 573091200)
createConvertToTicksTest(testConvertTimeToTicks9, 2015, 04, 01, 00, 00, 00, 575769600)
createConvertToTicksTest(testConvertTimeToTicks10, 2015, 05, 01, 00, 00, 00, 578361600)
createConvertToTicksTest(testConvertTimeToTicks11, 2015, 06, 01, 00, 00, 00, 581040000)
createConvertToTicksTest(testConvertTimeToTicks12, 2015, 07, 01, 00, 00, 00, 583632000)
createConvertToTicksTest(testConvertTimeToTicks13, 2015, 08, 01, 00, 00, 00, 586310400)
createConvertToTicksTest(testConvertTimeToTicks14, 2015, 09, 01, 00, 00, 00, 588988800)
createConvertToTicksTest(testConvertTimeToTicks15, 2015, 10, 01, 00, 00, 00, 591580800)
createConvertToTicksTest(testConvertTimeToTicks16, 2015, 11, 01, 00, 00, 00, 594259200)
createConvertToTicksTest(testConvertTimeToTicks17, 2015, 12, 01, 00, 00, 00, 596851200)

; first day of every month in a leap year
createConvertToTicksTest(testConvertTimeToTicks18, 2016, 01, 01, 00, 00, 00, 599529600)
createConvertToTicksTest(testConvertTimeToTicks19, 2016, 02, 01, 00, 00, 00, 602208000)
createConvertToTicksTest(testConvertTimeToTicks20, 2016, 03, 01, 00, 00, 00, 604713600)
createConvertToTicksTest(testConvertTimeToTicks21, 2016, 04, 01, 00, 00, 00, 607392000)
createConvertToTicksTest(testConvertTimeToTicks22, 2016, 05, 01, 00, 00, 00, 609984000)
createConvertToTicksTest(testConvertTimeToTicks23, 2016, 06, 01, 00, 00, 00, 612662400)
createConvertToTicksTest(testConvertTimeToTicks24, 2016, 07, 01, 00, 00, 00, 615254400)
createConvertToTicksTest(testConvertTimeToTicks25, 2016, 08, 01, 00, 00, 00, 617932800)
createConvertToTicksTest(testConvertTimeToTicks26, 2016, 09, 01, 00, 00, 00, 620611200)
createConvertToTicksTest(testConvertTimeToTicks27, 2016, 10, 01, 00, 00, 00, 623203200)
createConvertToTicksTest(testConvertTimeToTicks28, 2016, 11, 01, 00, 00, 00, 625881600)
createConvertToTicksTest(testConvertTimeToTicks29, 2016, 12, 01, 00, 00, 00, 628473600)

; on and around leap day
createConvertToTicksTest(testConvertTimeToTicks30, 2012, 02, 29, 23, 59, 59, 478483199)
createConvertToTicksTest(testConvertTimeToTicks31, 2012, 03, 01, 00, 00, 00, 478483200)

; some arbitrary tests
createConvertToTicksTest(testConvertTimeToTicks32, 2016, 03, 04, 13, 39, 02, 605021942)
createConvertToTicksTest(testConvertTimeToTicks33, 2017, 07, 21, 03, 54, 14, 648532454)

; minimum and maximum possible tick value
createConvertToTicksTest(testConvertTimeToTicks34, 1997, 01, 01, 00, 00, 00, 0)
createConvertToTicksTest(testConvertTimeToTicks35, 2133, 02, 07, 06, 28, 15, 4294967295)
