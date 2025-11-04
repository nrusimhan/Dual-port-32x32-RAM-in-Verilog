module tb_ram32;

    // -------------------------------
    // DUT I/O signals
    // -------------------------------
    reg clk, rst;
    reg [4:0] addr_a, addr_b;
    reg [31:0] data_in_a, data_in_b;
    reg we_a, we_b, re_a, re_b;
    wire [31:0] data_out_a, data_out_b;

    // -------------------------------
    // Instantiate the DUT
    // -------------------------------
    ram32 uut (
        .clk(clk),
        .rst(rst),
        .addr_a(addr_a),
        .addr_b(addr_b),
        .data_in_a(data_in_a),
        .data_in_b(data_in_b),
        .we_a(we_a),
        .we_b(we_b),
        .re_a(re_a),
        .re_b(re_b),
        .data_out_a(data_out_a),
        .data_out_b(data_out_b)
    );

    // -------------------------------
    // Clock generation (100 MHz)
    // -------------------------------
    initial clk = 0;
    always #5 clk = ~clk;  // 10 ns period

    // -------------------------------
    // Test sequence
    // -------------------------------
    initial begin
        // Initialize signals
        rst = 1;
        we_a = 0; we_b = 0;
        re_a = 0; re_b = 0;
        addr_a = 0; addr_b = 0;
        data_in_a = 0; data_in_b = 0;

        $display("------------------------------------------------------");
        $display("STARTING TESTBENCH FOR DUAL PORT 32x32 RAM");
        $display("------------------------------------------------------");

        // Apply reset for 2 cycles
        #3rst=0; 
        $display("\n[RESET RELEASED]n");
        // -------------------------------
        // WRITE TEST
        // -------------------------------
        $display("[1] WRITE TEST");
        addr_a = 5'd3;  data_in_a = 32'h98b7fda4; we_a = 1;
        addr_b = 5'd10; data_in_b = 32'hfacecafe; we_b = 1;

        #7; // Perform write at this clock
        we_a = 0; we_b = 0;
        $display("    -> Port A wrote 0x%h at addr %0d", data_in_a, addr_a);
        $display("    -> Port B wrote 0x%h at addr %0d", data_in_b, addr_b);

        // -------------------------------
        // READ TEST
        // -------------------------------
        $display("\n[2] READ TEST");
        addr_a = 5'd3;  re_a = 1;
        addr_b = 5'd10; re_b = 1;

        #13; // Outputs valid after this edge
        $display("    -> Port A read 0x%h from addr %0d", data_out_a, addr_a);
        $display("    -> Port B read 0x%h from addr %0d", data_out_b, addr_b);

        re_a = 0; re_b = 0;

        // -------------------------------
        // SIMULTANEOUS READ/WRITE TEST
        // -------------------------------
        $display("\n[3] SIMULTANEOUS OPERATION TEST");
        addr_a = 5'd15; data_in_a = 32'hcafebabe; we_a = 1;
        addr_b = 5'd10; re_b = 1;

        #4;
        we_a = 0; re_b = 0;
        $display("    -> Port A wrote 0x%h to addr %0d", data_in_a, addr_a);
        $display("    -> Port B read  0x%h from addr %0d", data_out_b, addr_b);

        // -------------------------------
        // VERIFY NEW WRITE
        // -------------------------------
        #7;
        $display("\n[4] READ BACK NEWLY WRITTEN VALUE (ADDR 15)");
        addr_a = 5'd15; re_a = 1;
        #12
        $display("    -> Port A read 0x%h from addr %0d", data_out_a, addr_a);
      

        // -------------------------------
        // END OF TEST
        // -------------------------------
        $display("\n------------------------------------------------------");
        $display("TEST COMPLETED SUCCESSFULLY");
        $display("------------------------------------------------------");
        
        $finish;
    end

endmodule
