`timescale 1ns/1ps

module gpio_bank #(
    parameter        BASE_ADDR = 32'h0000_0000,
    parameter [31:0] RW_MASK   = 32'h0000_0000,
    parameter [31:0] RO_MASK   = 32'h0000_0000,
    parameter [31:0] WO_MASK   = 32'h0000_0000
)(
    input  logic         i_clk,
    input  logic         i_rst_n,

    input  logic         i_req_valid,
    output logic         o_req_ready,
    input  logic [31:0]  i_req_addr,
    input  logic [31:0]  i_req_wdata,
    input  logic [3:0]   i_req_wmask,

    output logic         o_resp_valid,
    output logic [31:0]  o_resp_rdata,
    input  logic         i_resp_ready,

    input  logic [31:0]  i_gpio_bank0,
    output logic [31:0]  o_gpio_bank0
);

    logic [31:0] reg_data;
    logic resp_pending;

    wire [31:0] rw_wo_mask = RW_MASK | WO_MASK;

    wire sel = i_req_valid &&
               (i_req_addr[31:12] == BASE_ADDR[31:12]);

    assign o_req_ready  = !resp_pending;
    assign o_resp_valid = resp_pending;
    assign o_resp_rdata = reg_data & (RW_MASK | RO_MASK);

    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            resp_pending <= 1'b0;
            reg_data     <= 32'b0;
        end else begin
            reg_data <= (reg_data & ~RO_MASK) | (i_gpio_bank0 & RO_MASK);
            if (i_req_valid && o_req_ready && sel) begin
                if (i_req_wmask[0])
                    reg_data[7:0]   <= (reg_data[7:0]   & ~rw_wo_mask[7:0])   | (i_req_wdata[7:0]   & rw_wo_mask[7:0]);
                if (i_req_wmask[1])
                    reg_data[15:8]  <= (reg_data[15:8]  & ~rw_wo_mask[15:8])  | (i_req_wdata[15:8]  & rw_wo_mask[15:8]);
                if (i_req_wmask[2])
                    reg_data[23:16] <= (reg_data[23:16] & ~rw_wo_mask[23:16]) | (i_req_wdata[23:16] & rw_wo_mask[23:16]);
                if (i_req_wmask[3])
                    reg_data[31:24] <= (reg_data[31:24] & ~rw_wo_mask[31:24]) | (i_req_wdata[31:24] & rw_wo_mask[31:24]);

                resp_pending <= 1'b1;
            end
            else if (resp_pending && i_resp_ready) begin
                resp_pending <= 1'b0;
            end
        end
    end

    assign o_gpio_bank0 = reg_data & (RW_MASK | WO_MASK);
endmodule
