//The Datapath module for the game
module datapath ( slow_clock, fast_clock, resetb,
                  load_pcard1, load_pcard2, load_pcard3,
                  load_dcard1, load_dcard2, load_dcard3,				
                  pcard3_out,
                  pscore_out, dscore_out,
                  HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
						
input slow_clock, fast_clock, resetb;
input load_pcard1, load_pcard2, load_pcard3;
input load_dcard1, load_dcard2, load_dcard3;
output [3:0] pcard3_out;
output [3:0] pscore_out, dscore_out;
output [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;

reg[3:0] new_card;
reg [3:0] pcard1, pcard2, pcard3;	
reg [3:0] dcard1, dcard2, dcard3;				
wire [3:0] test;
localparam zero_value = 4'b0000;

dealcard dealcard(.clock(fast_clock), .resetb(resetb), .new_card(new_card));

always_ff @(posedge slow_clock, negedge resetb)
	begin
		if(resetb == 0) begin
			//Player Cards
			pcard1 <= zero_value;
			pcard2 <= zero_value;
			pcard3 <= zero_value;
			//Dealer Cards
			dcard1 <= zero_value;
			dcard2 <= zero_value;
			dcard3 <= zero_value;
		end else begin
			//Player Cards
			if(load_pcard1)
				pcard1 <= new_card;
			if(load_pcard2)
				pcard2 <= new_card;
			if(load_pcard3)
				pcard3 <= new_card;
			//Dealer Cards
			if(load_dcard1)
				dcard1 <= new_card;
			if(load_dcard2)
				dcard2 <= new_card;
			if(load_dcard3)
				dcard3 <= new_card;
		end
	end

//Display the player's cards
card7seg pcard1Hex(.HEX0(HEX0), .SW(pcard1));
card7seg pcard2Hex(.HEX0(HEX1), .SW(pcard2));
card7seg pcard3Hex(.HEX0(HEX2), .SW(pcard3));

//Display the dealer's cards
card7seg dcard1Hex(.HEX0(HEX3), .SW(dcard1));
card7seg dcard2Hex(.HEX0(HEX4), .SW(dcard2));
card7seg dcard3Hex(.HEX0(HEX5), .SW(dcard3));

assign pcard3_out = pcard3;
scorehand playerHand(.card1(pcard1), .card2(pcard2), .card3(pcard3), .total(pscore_out));
scorehand dealerHand(.card1(dcard1), .card2(dcard2), .card3(dcard3), .total(dscore_out));



endmodule
