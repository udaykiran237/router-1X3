package router_pkg;


//import uvm_pkg.sv
import uvm_pkg::*;

`include "uvm_macros.svh"

	//`include "tb_defs.sv"

`include "source_agt_config.sv"
`include "destination_agt_config.sv"
`include "env_config.sv"

`include "source_xtn.sv"
`include "source_seqs.sv" 
`include "source_driver.sv"
`include "source_monitor.sv"
`include "source_sequencer.sv"
`include "source_agt.sv"
`include "source_agt_top.sv"
 

`include "destination_xtn.sv"
`include "destination_seqs.sv" 
`include "destination_monitor.sv"
`include "destination_sequencer.sv"
`include "destination_driver.sv"
`include "destination_agt.sv"
`include "destination_agt_top.sv"
 
`include "score_board.sv"
`include "env.sv"

`include "test.sv"

endpackage
