# multi-mode-counter
This project is for Digital Verification Course. it was written in system verilog using Modelsim simulator.
## Aim
implement multi-mode counter and verify the implementation
## FSM
![FSM of multimode counter](https://user-images.githubusercontent.com/104006521/231020488-68736ced-9ef3-4e0d-a38c-49cd502e8fb9.png)
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
## Demonstration 
[here](https://drive.google.com/file/d/1bhpKHcPsme2RXA4gfMXhnw53qTx9Ovgv/view?usp=sharing)

