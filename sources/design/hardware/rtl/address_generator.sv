
module address_generator #(
  parameter WIDTH = 48
) (
  input              clock,
  input              resetn,
  input              initialize,
  input              enable,
  input              mode_selector,
  input  [WIDTH-1:0] range_start,
  input  [WIDTH-1:0] range_increment,
  input  [WIDTH-1:0] lfsr_seed,
  input  [WIDTH-1:0] lfsr_fibonacci_taps,
  input  [WIDTH-2:0] lfsr_gallois_taps,
  input  [WIDTH-1:0] lfsr_mask,
  input  [WIDTH-1:0] final_mask,
  output [WIDTH-1:0] generated_address
);

logic [WIDTH-1:0] address;
logic [WIDTH-1:0] address_next;

logic lfsr_feedback;

always_comb begin
  address_next = address;
  if (enable) begin
    if (mode_selector) begin
      lfsr_feedback = ^(address & lfsr_fibonacci_taps);
      address_next = lfsr_mask & { lfsr_feedback , ( {WIDTH-1{lfsr_feedback}} & lfsr_gallois_taps ) ^ address[WIDTH-1:1] };
    end else begin
      address_next = address_next + range_increment;
    end
  end
end

always_ff @(posedge clock or negedge resetn) begin
  if (!resetn) begin
    address <= 48'd0;
  end else if (initialize) begin
    if (mode_selector) begin
      address <= lfsr_seed;
    end else begin
      address <= range_start;
    end
  end else begin
    address <= address_next;
  end
end

assign generated_address = address & final_mask;

endmodule
