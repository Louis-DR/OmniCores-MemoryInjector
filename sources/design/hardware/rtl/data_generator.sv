
module data_generator #(
  parameter WIDTH      = 256,
  parameter SHIFT_LOG2 =   2,
  parameter LFSR_WIDTH =  32,
  parameter LFSR_TAPS  =  31'b0100011000000000000000000000000
) (
  input                clock,
  input                resetn,
  input                initialize,
  input                enable,
  input                mode_selector,
  input    [WIDTH-1:0] initial_value,
  input                shift_enable,
  input                shift_direction,
  input  [WIDTH/8-1:0] final_byte_mask,
  output   [WIDTH-1:0] generated_data
);

logic [WIDTH-1:0] data;
logic [WIDTH-1:0] data_next;
logic [WIDTH-1:0] data_masked;

always_comb begin
  data_next = data;
  if (mode_selector) begin
    for (int lfsr_idx = 0 ; lfsr_idx < WIDTH ; lfsr_idx = lfsr_idx + LFSR_WIDTH) begin
      data_next [ lfsr_idx+LFSR_WIDTH-1 : lfsr_idx ] = { data[lfsr_idx] , ( {LFSR_WIDTH-1{data[lfsr_idx]}} & LFSR_TAPS ) ^ data[ lfsr_idx+LFSR_WIDTH-1 : lfsr_idx+1 ] };
    end
  end else begin
    if (shift_enable) begin
      if (shift_direction) begin
        data_next = { data[0] , data[WIDTH-1:1] };
      end else begin
        data_next = { data[WIDTH-2:0] , data[WIDTH-1] };
      end
    end
  end
end

always_ff @(posedge clock or negedge resetn) begin
  if (!resetn) begin
    data <= 256'd0;
  end else if (initialize) begin
    data <= initial_value;
  end else begin
    data <= data_next;
  end
end

always_comb begin
  for (int mask_byte = 0 ; mask_byte < WIDTH ; mask_byte = mask_byte + 8) begin
    data_masked [ mask_byte+7 : mask_byte ] = final_byte_mask[mask_byte/8] ? data [ mask_byte+7 : mask_byte ] : 8'd0;
  end
end

assign generated_data = data_masked;

endmodule
