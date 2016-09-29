//The state machine for controlling the game
module statemachine ( slow_clock, resetb,
                      dscore, pscore, pcard3,
                      load_pcard1, load_pcard2,load_pcard3,
                      load_dcard1, load_dcard2, load_dcard3,
                      player_win_light, dealer_win_light);
							 
input slow_clock, resetb;
input [3:0] dscore, pscore, pcard3;
output reg load_pcard1, load_pcard2, load_pcard3;
output reg load_dcard1, load_dcard2, load_dcard3;
output reg player_win_light, dealer_win_light;

reg [3:0] current_state, next_state;

//States
localparam s_start     	= 4'b0000; 
localparam s_dealP1    	= 4'b0001;
localparam s_dealD1    	= 4'b0010;
localparam s_dealP2    	= 4'b0011;
localparam s_dealD2    	= 4'b0100;
localparam s_compare1  	= 4'b0101;
localparam s_dealP3    	= 4'b0110;
localparam s_dealD3    	= 4'b0111;
localparam s_evaluate  	= 4'b1000;
localparam s_player		= 4'b1001;
localparam s_dealer 	   = 4'b1010;
localparam s_tie       	= 4'b1011;

localparam faceCardStart = 4'b1011;
wire [3:0] pcard3score;
assign pcard3score = ((pcard3 < faceCardStart) ? pcard3 : 0) % 10;
 

//The input combinational logic
always_comb
	begin
		case(current_state)
			s_start:	
						next_state = s_dealP1;
			s_dealP1:	
						next_state = s_dealD1;
			s_dealD1:	
						next_state = s_dealP2;
			s_dealP2:	
						next_state = s_dealD2;
			s_dealD2:
						next_state = s_compare1;
			s_compare1: 
    
						if(pscore >= 8 || dscore >= 8)
							next_state = s_evaluate;
						else if(pscore <= 5)
							next_state = s_dealP3;
						else
							if(dscore <= 5)
								next_state = s_dealD3;
							else 
								next_state = s_evaluate;
			s_dealP3:
						if(dscore == 7)
							next_state = s_evaluate;
						else if(dscore == 6)
							if(pcard3score == 6 || pcard3score == 7)
								next_state = s_dealD3;
							else
								next_state = s_evaluate;
						else if(dscore == 5)
							if(pcard3score >= 4)
								if(pcard3score <= 7)
									next_state = s_dealD3;
								else
								next_state = s_evaluate;
							else
								next_state = s_evaluate;
						else if(dscore == 4)
							if(pcard3score >= 2)
								if(pcard3score <= 7)
									next_state = s_dealD3;
								else
								next_state = s_evaluate;
							else
								next_state = s_evaluate;
						else
							if(pcard3score != 8)
								next_state = s_dealD3;
							else
								next_state = s_evaluate;					
			s_dealD3:
						next_state = s_evaluate;
			s_evaluate:
						if(pscore > dscore)
							next_state = s_player;
						else if(dscore > pscore)
							next_state = s_dealer;
						else
							next_state = s_tie;
			s_player:
					next_state = s_player;
			s_dealer:
					next_state = s_dealer;
			s_tie:
					next_state = s_tie;
			default: 
					next_state = s_start;
		endcase
	end

//The sequential logic for updating the current_state
always_ff @(posedge slow_clock, negedge resetb)
	begin
		if(resetb == 0)
			current_state = s_start;
		else
			current_state = next_state;
	end

//The output combinational
always_comb
	begin
		case(current_state)
			s_start:	
					begin
						load_pcard1 = 0;
						load_pcard2 = 0;
						load_pcard3 = 0;
						load_dcard1 = 0;
						load_dcard2 = 0;
						load_dcard3 = 0;
						player_win_light = 0;
						dealer_win_light = 0;
					end
			s_dealP1:	
					begin
						load_pcard1 = 1;
						load_pcard2 = 0;
						load_pcard3 = 0;
						load_dcard1 = 0;
						load_dcard2 = 0;
						load_dcard3 = 0;
						player_win_light = 0;
						dealer_win_light = 0;
					end
			s_dealD1:	
					begin
						load_pcard1 = 0;
						load_pcard2 = 0;
						load_pcard3 = 0;
						load_dcard1 = 1;
						load_dcard2 = 0;
						load_dcard3 = 0;
						player_win_light = 0;
						dealer_win_light = 0;
					end
			s_dealP2:	
					begin
						load_pcard1 = 0;
						load_pcard2 = 1;
						load_pcard3 = 0;
						load_dcard1 = 0;
						load_dcard2 = 0;
						load_dcard3 = 0;
						player_win_light = 0;
						dealer_win_light = 0;
					end
			s_dealD2:	
					begin
						load_pcard1 = 0;
						load_pcard2 = 0;
						load_pcard3 = 0;
						load_dcard1 = 0;
						load_dcard2 = 1;
						load_dcard3 = 0;
						player_win_light = 0;
						dealer_win_light = 0;
					end
			s_compare1: 
					begin
						load_pcard1 = 0;
						load_pcard2 = 0;
						load_pcard3 = 0;
						load_dcard1 = 0;
						load_dcard2 = 0;
						load_dcard3 = 0;
						player_win_light = 0;
						dealer_win_light = 0;
					end
			s_dealP3:	
					begin	
						load_pcard1 = 0;
						load_pcard2 = 0;
						load_pcard3 = 1;
						load_dcard1 = 0;
						load_dcard2 = 0;
						load_dcard3 = 0;
						player_win_light = 0;
						dealer_win_light = 0;	
					end		
			s_dealD3:	
					begin
						load_pcard1 = 0;
						load_pcard2 = 0;
						load_pcard3 = 0;
						load_dcard1 = 0;
						load_dcard2 = 0;
						load_dcard3 = 1;
						player_win_light = 0;
						dealer_win_light = 0;
					end
			s_evaluate:
					begin
						load_pcard1 = 0;
						load_pcard2 = 0;
						load_pcard3 = 0;
						load_dcard1 = 0;
						load_dcard2 = 0;
						load_dcard3 = 0;
						player_win_light = 0;
						dealer_win_light = 0;
					end
			s_player:
					begin
						load_pcard1 = 0;
						load_pcard2 = 0;
						load_pcard3 = 0;
						load_dcard1 = 0;
						load_dcard2 = 0;
						load_dcard3 = 0;
						player_win_light = 1;
						dealer_win_light = 0;
					end
			s_dealer:
					begin
						load_pcard1 = 0;
						load_pcard2 = 0;
						load_pcard3 = 0;
						load_dcard1 = 0;
						load_dcard2 = 0;
						load_dcard3 = 0;
						player_win_light = 0;
						dealer_win_light = 1;
					end
			s_tie:
					begin
						load_pcard1 = 0;
						load_pcard2 = 0;
						load_pcard3 = 0;
						load_dcard1 = 0;
						load_dcard2 = 0;
						load_dcard3 = 0;
						player_win_light = 1;
						dealer_win_light = 1;
					end
			default:
					begin 
						load_pcard1 = 0;
						load_pcard2 = 0;
						load_pcard3 = 0;
						load_dcard1 = 0;
						load_dcard2 = 0;
						load_dcard3 = 0;
						player_win_light = 0;
						dealer_win_light = 0;
					end
		endcase	
	end
	
endmodule
			