/* Design */ 
module multi_mode_counter  #(parameter MULTI_MODE_COUNTER_WIDTH, parameter COUNTERS_WIDTH)(mode,init,initialValue,clk,rst,who,winner,loser,count,GAMEOVER);

    //--------------defination part--------------
    // Inputs
    input wire [1:0]mode;
    input wire init, clk, rst;
    input wire [MULTI_MODE_COUNTER_WIDTH-1:0]initialValue;
    // Outputs
    output reg [MULTI_MODE_COUNTER_WIDTH-1:0]count;  
    output wire [1:0]who;
    output wire winner,loser;
    output reg GAMEOVER;
    // storing elements
    reg [COUNTERS_WIDTH-1:0]winner_count;
    reg [COUNTERS_WIDTH-1:0]loser_count;
    // Counters maximum values
    integer MULTICOUNTER_MAX_VALUE = $pow(2, MULTI_MODE_COUNTER_WIDTH)-1;
    integer COUNTERS_MAX_VALUE = $pow(2, COUNTERS_WIDTH)-1;
    // Modes
    parameter [1:0]COUNT_UP_BY_1   = 2'b00;
    parameter [1:0]COUNT_UP_BY_2   = 2'b01;
    parameter [1:0]COUNT_DOWN_BY_1 = 2'b10;
    parameter [1:0]COUNT_DOWN_BY_2 = 2'b11;
    // continous assignment
    assign loser = (count == 0);
    assign winner = (count == MULTICOUNTER_MAX_VALUE);
    assign who = (!GAMEOVER)?0:((winner_count==COUNTERS_MAX_VALUE)?2'b10:2'b01);
	
  
    //--------------trigger part--------------
    // asynchronous reset for initial state
    always @(rst) begin
      if(rst) begin
         GAMEOVER <= 0;
         winner_count <= 0;
	     loser_count <= 0;
         case(mode)
		       COUNT_UP_BY_1:	 count <= 0;
	           COUNT_UP_BY_2:    count <= 0;
		       COUNT_DOWN_BY_1:  count <= MULTICOUNTER_MAX_VALUE;
	           COUNT_DOWN_BY_2:  count <= MULTICOUNTER_MAX_VALUE;
         endcase
      end
    end
  
    // count logic
    always @(posedge clk) begin
      if(!rst) begin
          if(init == 1) begin
                   case(mode)
			       COUNT_UP_BY_1:	 count <= initialValue;     
                   COUNT_UP_BY_2:    begin if(initialValue % 2 == 0)
                                        count <= initialValue;
                                     else
                                       count <= initialValue + 1;
                                     end 
		           COUNT_DOWN_BY_1:  count <= initialValue;
                   COUNT_DOWN_BY_2:  begin if ( (MULTICOUNTER_MAX_VALUE % 2) == (initialValue %2))
                                        count <= initialValue;
                                     else
                                        count <= initialValue - 1;
                                     end 
                   endcase
          end
          else if(GAMEOVER == 1) begin
                   case(mode)
			       COUNT_UP_BY_1:	 count <= 0;        
	    	       COUNT_UP_BY_2:    count <= 0; 
		           COUNT_DOWN_BY_1:  count <= MULTICOUNTER_MAX_VALUE;
	               COUNT_DOWN_BY_2:  count <= MULTICOUNTER_MAX_VALUE;
                   endcase
          end
          else begin        
                   case(mode)
			       COUNT_UP_BY_1:	 count <= count + 1;   
                   COUNT_UP_BY_2:    begin if(count % 2 == 0)
                                        count <= count + 2; 
                                     else
                                       count <= count + 1;
                                     end 
		           COUNT_DOWN_BY_1:  count <= count - 1;
                   COUNT_DOWN_BY_2:  begin if ( (MULTICOUNTER_MAX_VALUE % 2) == (count %2))
                                        count <= count - 2;
                                     else
                                        count <= count - 1;
                                     end 
                   endcase
          end
      end
   end	 
   // increase winner and loser counters
   always @(count or negedge GAMEOVER) begin
     if(count == MULTICOUNTER_MAX_VALUE) begin
      	winner_count <= winner_count + 1;
     end
     else if (count == 0) begin
        loser_count <= loser_count + 1;
     end
   end
   // raise GAMEOVRE for one clock
   always @(loser_count or winner_count) begin
      if(loser_count == COUNTERS_MAX_VALUE || winner_count == COUNTERS_MAX_VALUE)
      begin
          GAMEOVER <= 1;
          @(posedge clk);
          GAMEOVER <= 0;
          winner_count <= 0;
          loser_count <= 0;
      end  
   end 
  
endmodule
