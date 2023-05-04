# multi-mode-counter
This project is for Digital Verification Course. it was written in system verilog using Modelsim simulator.
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
# **assumptions**
**1- Counter bit is determined according to** 
- parameter MULTICOUNTER_SIZE = 5;
			 
**2- Clock duration is determined according to**
- parameter CYCLE = 4;
			 
**3- Synchronous load**

**4- Asynchronous rst but count is updated at posedge of clock only**
- if (rst = 1)                                              then  (counter = 0 , winner_counter = 0 , loser_counter = 0)
-	 if (transaction from 1 to 0  and  mode = COUNT_UP_BY_1)    then  (counter = 0)
-	 if (transaction from 1 to 0  and  mode = COUNT_UP_BY_2)    then  (counter = 0)
-	 if (transaction from 1 to 0  and  mode = COUNT_DOWN_BY_1)  then  (counter = max value)
-	 if (transaction from 1 to 0  and  mode = COUNT_DOWN_BY_2)  then  (counter = max value)

**5- Winner signal is kept high when ever counter value is maximum**

**6- Loser signal is kept low when ever counter value is 0**

**7- GAMEOVER is kept high for one clock cycle then all counters are clear**
 -      winner_count <= 0;
-	     loser_count <= 0;
-	     if (mode = COUNT_UP_BY_1)    then  (counter = 0)
-	     if (mode = COUNT_UP_BY_2)    then  (counter = 0)
-	     if (mode = COUNT_DOWN_BY_1)  then  (counter = max value)
-	     if (mode = COUNT_DOWN_BY_2)  then  (counter = max value
