`timescale 1ns/1ps
module rom #(
    parameter BASE_ADDR  = 32'h0000_0000,
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter MEM_DEPTH  = 256  // number of 32-bit words
)(
    input  logic                  i_clk,
    input  logic                  i_rst_n,

    // CPU interface
    input  logic                  i_req_valid,
    output logic                  o_req_ready,
    input  logic [ADDR_WIDTH-1:0] i_req_addr,
    input  logic [3:0]            i_req_wmask,
    input  logic [DATA_WIDTH-1:0] i_req_wdata,

    output logic                  o_resp_valid,
    input  logic                  i_resp_ready,
    output logic [DATA_WIDTH-1:0] o_resp_rdata
);
    logic [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];
    localparam ADDR_BITS = $clog2(MEM_DEPTH);

    logic [ADDR_WIDTH-1:0] phys_addr;
    assign phys_addr = i_req_addr - BASE_ADDR;
    

    // initial begin
    //     $readmemh("/Volumes/fileserver/Projects_/SoC/soft/boot_rom/boot_rom.hex", mem);
    // end

    // initial begin
    //     $readmemh("/mnt/fileserver/Projects_/SoC/soft/boot_rom/boot_rom.hex", mem);
    // end

    initial begin
        $readmemh("/soft/boot_rom/boot_rom.hex", mem);
    end
    

    logic resp_pending;
    logic [DATA_WIDTH-1:0] rdata_reg;
    assign o_req_ready = !resp_pending;
    assign o_resp_valid = resp_pending;
    assign o_resp_rdata = rdata_reg;

    always_ff @(posedge i_clk) begin
        if (!i_rst_n) begin
            resp_pending <= 1'b0;
            rdata_reg    <= {DATA_WIDTH{1'b0}};
        end else begin
            if (i_req_valid && o_req_ready) begin
                if (i_req_wmask != 4'b0) begin
                    $fatal("ROM is read only!");
                end
                rdata_reg <= mem[phys_addr[ADDR_BITS+1:2]];
                resp_pending <= 1'b1;
            end else if (resp_pending && i_resp_ready) begin
                resp_pending <= 1'b0;
            end
        end
    end
endmodule: rom
