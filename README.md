# multi-mode-counter
This project is for Digital Verification Course. it was written in system verilog using EDA Playground.
## Aim
implement multi-mode counter and verify the implementation
## Procedure Details
- Given the following specifications, write a SV code to describe the system.
- You have a multi-mode counter. It can count up, down, by ones and by twos. There is
a two-bit control bus input indicating which one of the four modes is active.

###  Control Value   :     Function
###    00            :     Count up by 1’s.
###    01            :     Count up by 2’s.
###    10            :     Count down by 1’s.
###    11            :     Count down by 2’s.

- You also have an initial value input and a control signal called INIT. When INIT is 1,
the initial value is parallelly loaded into the counter.
- Whenever the count is equal to all zeros, set a signal called LOSER high. When the
count is all ones, set a signal called WINNER high. In either case, the set signal
should remain high for only one cycle.
- With a pair of plain binary counters, count the number of times WINNER and LOSER
goes high. When one of them reaches 15, set an output called GAMEOVER high. If
the game is over because LOSER got to 15 first, set a two-bit output called WHO to
2’b01. If the game is over because WINNER got to 15 first, set WHO to 2’b10. WHO
should start at 2’b00 and return to it after each game over.
- Then synchronously clear all the counters and start over. The game never ends.
- Does your design need a clock? Does it need an asynchronous reset? A synchronous
reset? Decide for yourself and explain your choices.
- You are not limited in either the number of functional blocks or the number of
modules used.
- Develop a simple test bench that generates the required inputs to test the different
scenarios, and make sure the design is correct by investigating the generated wave
diagrams.

# assumptions

a) At COUNT_UP_BY_1 mode the counter will count as 
0, 1, 2, 3, 4, ....... 31, 0, 1, 2, 3, ...... and so on
          
b) At COUNT_UP_BY_2 mode the counter will count as 
0, 2, 4, 6, 8, ....... 30, 0, 2, 4, 6, ......... and so on   (no odd numbers)
note: even if i try to load odd number, counter wonot have odd numbers

c) At COUNT_DOWN_BY_1 mode the counter will count as 
31, 30, 29, 28, 27, 26, ....... 0, 31, 30, 29, 28, ......... and so on

d) At COUNT_DOWN_BY_2 mode the counter will count as 
31, 29, 27, 25, 23, ..... 1, 31,31, 29, 27, 25, ......... and so on  (no even numbers)
note: even if i try to load even number, counter wonot have even numbers

e)    if you load an odd value when it's in up by 2 
      the counter will continue to count up by 1 until the next even number is reached, 
      then switch to counting up by 2.
          
      For example, if you load the odd value 7 into the counter when it's in up by 2 mode,
      the counter will first count up to 8 (by 1), then switch to up by 2 mode and count up to 10      
        
f)    if you load an even value when it's in down by 2 
      the counter will continue to count down by 1 until the previous odd number is reached, 
      then switch to counting down by 2.
          
      For example, if you load the odd value 8 into the counter when it's in down by 2 mode,
      the counter will first count up to 7 (by 1), then switch to down by 2 mode and count up to 5
      
g)    same idea when we are switching between modes
