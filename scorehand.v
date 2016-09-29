//The module for evaluating each player's score given their cards
module scorehand (card1, card2, card3, total);

input [3:0] card1, card2, card3;
output [3:0] total; 

localparam faceCardStart = 4'b1011;

assign total = (((card1 < faceCardStart) ? card1 : 0) +	
		((card2 < faceCardStart) ? card2 : 0) +
		((card3 < faceCardStart) ? card3 : 0)) % 10;
endmodule
	