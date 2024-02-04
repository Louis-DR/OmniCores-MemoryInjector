
module axi_injector_tb (
  // ┌─────────────────────────────┐
  // │ Control input APB interface │
  // └─────────────────────────────┘
  input          control_pclock,
  input          control_presetn,
  input          control_psel,
  input          control_penable,
  output         control_pready,
  input    [2:0] control_pprot,
  input   [31:0] control_paddr,
  input          control_pwrite,
  input   [31:0] control_pwdata,
  input    [7:0] control_pstrb,
  output  [31:0] control_prdata,
  output         control_pslverr,
  // ┌───────────────────────────┐
  // │ Data output AXI interface │
  // └───────────────────────────┘
  input          data_aclock,
  input          data_aresetn,
  // Write request channel
  output  [23:0] data_awid,
  output  [31:0] data_awaddr,
  output   [7:0] data_awlen,
  output   [2:0] data_awsize,
  output   [1:0] data_awburst,
  output   [2:0] data_awprot,
  output   [3:0] data_awqos,
  output         data_awvalid,
  input          data_awready,
  // Write data channel
  output [255:0] data_wdata,
  output  [31:0] data_wstrb,
  output         data_wlast,
  output         data_wvalid,
  input          data_wready,
  // Write response channel
  input   [23:0] data_bid,
  input    [1:0] data_bresp,
  input          data_bvalid,
  output         data_bready,
  // Read request channel
  output  [23:0] data_arid,
  output  [31:0] data_araddr,
  output   [7:0] data_arlen,
  output   [2:0] data_arsize,
  output   [1:0] data_arburst,
  output   [2:0] data_arprot,
  output   [3:0] data_arqos,
  output         data_arvalid,
  input          data_arready,
  // Read data response channel
  input   [23:0] data_rid,
  input  [255:0] data_rdata,
  input    [1:0] data_rresp,
  input          data_rlast,
  input          data_rvalid,
  output         data_rready
);

axi_injector axi_injector (
  .control_pclock  ( control_pclock  ),
  .control_presetn ( control_presetn ),
  .control_psel    ( control_psel    ),
  .control_penable ( control_penable ),
  .control_pready  ( control_pready  ),
  .control_pprot   ( control_pprot   ),
  .control_paddr   ( control_paddr   ),
  .control_pwrite  ( control_pwrite  ),
  .control_pwdata  ( control_pwdata  ),
  .control_pstrb   ( control_pstrb   ),
  .control_prdata  ( control_prdata  ),
  .control_pslverr ( control_pslverr ),
  .data_aclock     ( data_aclock     ),
  .data_aresetn    ( data_aresetn    ),
  .data_awid       ( data_awid       ),
  .data_awaddr     ( data_awaddr     ),
  .data_awlen      ( data_awlen      ),
  .data_awsize     ( data_awsize     ),
  .data_awburst    ( data_awburst    ),
  .data_awprot     ( data_awprot     ),
  .data_awqos      ( data_awqos      ),
  .data_awvalid    ( data_awvalid    ),
  .data_awready    ( data_awready    ),
  .data_wdata      ( data_wdata      ),
  .data_wstrb      ( data_wstrb      ),
  .data_wlast      ( data_wlast      ),
  .data_wvalid     ( data_wvalid     ),
  .data_wready     ( data_wready     ),
  .data_bid        ( data_bid        ),
  .data_bresp      ( data_bresp      ),
  .data_bvalid     ( data_bvalid     ),
  .data_bready     ( data_bready     ),
  .data_arid       ( data_arid       ),
  .data_araddr     ( data_araddr     ),
  .data_arlen      ( data_arlen      ),
  .data_arsize     ( data_arsize     ),
  .data_arburst    ( data_arburst    ),
  .data_arprot     ( data_arprot     ),
  .data_arqos      ( data_arqos      ),
  .data_arvalid    ( data_arvalid    ),
  .data_arready    ( data_arready    ),
  .data_rid        ( data_rid        ),
  .data_rdata      ( data_rdata      ),
  .data_rresp      ( data_rresp      ),
  .data_rlast      ( data_rlast      ),
  .data_rvalid     ( data_rvalid     ),
  .data_rready     ( data_rready     )
);

`ifdef COCOTB_SIM
// Record waveform
initial begin
  $dumpfile("waveform.vcd");
  $dumpvars;
  #1;
end
`endif

endmodule
