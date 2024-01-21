
module axi_injector (
  // ┌─────────────────────────────┐
  // │ Control input APB interface │
  // └─────────────────────────────┘
  input          control_pclk,
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
  input          data_aclk,
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

logic unused_ok;
assign unused_ok = |{
  control_pclk,
  control_presetn,
  control_psel,
  control_penable,
  control_pprot,
  control_paddr,
  control_pwrite,
  control_pwdata,
  control_pstrb,
  data_aclk,
  data_aresetn,
  data_awready,
  data_wready,
  data_bid,
  data_bresp,
  data_bvalid,
  data_arready,
  data_rid,
  data_rdata,
  data_rresp,
  data_rlast,
  data_rvalid,
  1'b0
};

assign control_pready  = '0;
assign control_prdata  = '0;
assign control_pslverr = '0;
assign data_awid       = '0;
assign data_awaddr     = '0;
assign data_awlen      = '0;
assign data_awsize     = '0;
assign data_awburst    = '0;
assign data_awprot     = '0;
assign data_awqos      = '0;
assign data_awvalid    = '0;
assign data_wdata      = '0;
assign data_wstrb      = '0;
assign data_wlast      = '0;
assign data_wvalid     = '0;
assign data_bready     = '0;
assign data_arid       = '0;
assign data_araddr     = '0;
assign data_arlen      = '0;
assign data_arsize     = '0;
assign data_arburst    = '0;
assign data_arprot     = '0;
assign data_arqos      = '0;
assign data_arvalid    = '0;
assign data_rready     = '0;

endmodule
