module ram32(
    input clk,
    input rst,                     // Active-high synchronous reset
    input [4:0] addr_a, addr_b,
    input [31:0] data_in_a, data_in_b,
    input we_a, we_b,              // Write enables
    input re_a, re_b,              // Read enables
    output reg [31:0] data_out_a, data_out_b
);

    // 32 words of 32 bits each
    reg [31:0] mem [0:31];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all output registers
            data_out_a <= 32'd0;
            data_out_b <= 32'd0;
        end 
        else begin
            // ---- Port A ----
            if (we_a)
                mem[addr_a] <= data_in_a;        // Write
            else if (re_a)
                data_out_a <= mem[addr_a];       // Read
            if(!re_a)
                data_out_a <= 32'b0;             // High impedance

            // ---- Port B ----
            if (we_b)
                mem[addr_b] <= data_in_b;        // Write
            else if (re_b)
                data_out_b <= mem[addr_b];       // Read
            if(!re_b)
                data_out_b <= 32'b0;
        end
    end

endmodule
