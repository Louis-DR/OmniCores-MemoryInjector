
module axi_injector (
  // ┌─────────────────────────────┐
  // │ Control input APB interface │
  // └─────────────────────────────┘
  input          control_pclk;
  input          control_presetn;
  input          control_psel;
  input          control_penable;
  output         control_pready;
  input    [2:0] control_pprot;
  input   [31:0] control_paddr;
  input          control_pwrite;
  input   [31:0] control_pwdata;
  input    [7:0] control_pstrb;
  output  [31:0] control_prdata;
  output         control_pslverr;
  // ┌───────────────────────────┐
  // │ Data output AXI interface │
  // └───────────────────────────┘
  input          data_aclk;
  input          data_aresetn;
  // Write request channel
  output  [23:0] data_awid;
  output  [31:0] data_awaddr;
  output   [7:0] data_awlen;
  output   [2:0] data_awsize;
  output   [1:0] data_awburst;
  output   [2:0] data_awprot;
  output   [3:0] data_awqos;
  output         data_awvalid;
  input          data_awready;
  // Write data channel
  output [255:0] data_wdata;
  output  [31:0] data_wstrb;
  output         data_wlast;
  output         data_wvalid;
  input          data_wready;
  // Write response channel
  input   [23:0] data_bid;
  input    [1:0] data_bresp;
  input          data_bvalid;
  output         data_bready;
  // Read request channel
  output  [23:0] data_arid;
  output  [31:0] data_araddr;
  output   [7:0] data_arlen;
  output   [2:0] data_arsize;
  output   [1:0] data_arburst;
  output   [2:0] data_arprot;
  output   [3:0] data_arqos;
  output         data_arvalid;
  input          data_arready;
  // Read data response channel
  input   [23:0] data_rid;
  input  [255:0] data_rdata;
  input    [1:0] data_rresp;
  input          data_rlast;
  input          data_rvalid;
  output         data_rready;
);

endmodule
