/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Module: RL_LJ_Evaluation_1st_Order.v
//
//	Function: Evaluate the piarwise LJ force between 2 particles using 1st order interpolation (interpolation index is generated in Matlab (under Ethan_GoldenModel/Matlab_Interpolation))
// 			1 tile of force pipeline, without filter
//				Taking 2 particles' position data as input
//				
//
// Dependency:
// 			RL_Evaluate_Pairs_LJ_1st_Order.v      (11 cycles)
//				r2_compute.v      (13 cycles)
//
//	Latency: Between Start and first valid: 13+11=24 cycles
//
// Created by: Chen Yang 07/25/18
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RL_LJ_Evaluation_1st_Order
#(
	parameter DATA_WIDTH 				= 32,
	parameter INTERPOLATION_ORDER		= 1,
	parameter SEGMENT_NUM				= 14,
	parameter SEGMENT_WIDTH				= 4,
	parameter BIN_WIDTH					= 8,
	parameter BIN_NUM						= 256,
	parameter LOOKUP_NUM					= SEGMENT_NUM * BIN_NUM,			// SEGMENT_NUM * BIN_NUM
	parameter LOOKUP_ADDR_WIDTH		= SEGMENT_WIDTH + BIN_WIDTH		// log LOOKUP_NUM / log 2
)
(
	input  clock,
	input  resetn,
	input  ivalid,
	input  iready,
	output ovalid,
	output oready,
	input  [DATA_WIDTH-1:0] ref_x,
	input  [DATA_WIDTH-1:0] ref_y,
	input  [DATA_WIDTH-1:0] ref_z,
	input  [DATA_WIDTH-1:0] neighbor_x,
	input  [DATA_WIDTH-1:0] neighbor_y,
	input  [DATA_WIDTH-1:0] neighbor_z,	
	output [DATA_WIDTH-1:0] forceoutput_x,
	output [DATA_WIDTH-1:0] forceoutput_y,
	output [DATA_WIDTH-1:0] forceoutput_z
);

	assign oready = iready;

	//////////////////////////////////////////////////////////////////////////////////////
	// Wires connection r2_evaluation and force_evaluation
	//////////////////////////////////////////////////////////////////////////////////////
	
	wire [DATA_WIDTH-1:0] r2;
	wire r2_valid;
	wire [DATA_WIDTH-1:0] dx;
	wire [DATA_WIDTH-1:0] dy;
	wire [DATA_WIDTH-1:0] dz;
	
	
	r2_compute #(DATA_WIDTH) r2_evaluate(
		.clk(clock),
		.rst(!resetn),
		.enable(ivalid),						// Connect to FSM controller
		.refx(ref_x),
		.refy(ref_y),
		.refz(ref_z),
		.posx(neighbor_x),
		.posy(neighbor_y),
		.posz(neighbor_z),
		.r2(r2),										// Connect to RL_Evaluate_Pairs_LJ.r2
		.dx_out(dx),								// Connect to RL_Evaluate_Pairs_LJ.dx
		.dy_out(dy),								// Connect to RL_Evaluate_Pairs_LJ.dy
		.dz_out(dz),								// Connect to RL_Evaluate_Pairs_LJ.dz
		.r2_valid(r2_valid)						// Connect to RL_Evaluate_Pairs_LJ.r2_valid
		);

	RL_Evaluate_Pairs_LJ_1st_Order #(
		DATA_WIDTH,
		SEGMENT_NUM,
		SEGMENT_WIDTH,
		BIN_WIDTH,
		BIN_NUM,
		LOOKUP_NUM,
		LOOKUP_ADDR_WIDTH
	)
	RL_Evaluate_Pairs_LJ(
		.clk(clock),
		.rst(!resetn),
		.r2_valid(r2_valid),						// Connect to r2_compute.r2_valid
		.r2(r2),										// Connect to r2_compute.r2
		.dx(dx),										// Connect to r2_compute.dx
		.dy(dy),										// Connect to r2_compute.dy
		.dz(dz),										// Connect to r2_compute.dz
		.LJ_Force_X(forceoutput_x),			// Connect to output
		.LJ_Force_Y(forceoutput_y),			// Connect to output
		.LJ_Force_Z(forceoutput_z),			// Connect to output
		.LJ_force_valid(ovalid)	// Connect to output
		);

endmodule


