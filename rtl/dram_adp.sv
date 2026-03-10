`timescale 1ns/1ps
/* verilator lint_off CASEINCOMPLETE */
module dram_adp #(
    parameter CORE_BASE = 32'h0000_0000,
    parameter PHYS_BASE = 32'h0000_0000
)(
    input  logic         clk,
    input  logic         rst_n,

    // ===== CORE SIDE =====
    input  logic         i_req_valid,
    output logic         o_req_ready,
    input  logic [31:0]  i_req_addr,
    input  logic [3:0]   i_req_wmask,
    input  logic [31:0]  i_req_wdata,

    output logic         o_resp_valid,
    input  logic         i_resp_ready,
    output logic [31:0]  o_resp_rdata,

    // ===== AXI WRITE ADDRESS =====
    output logic [31:0]  awaddr,
    output logic [2:0]   awsize,
    output logic [1:0]   awburst,
    output logic [3:0]   awlen,
    output logic         awvalid,
    input  logic         awready,

    // ===== AXI WRITE DATA =====
    output logic [31:0]  wdata,
    output logic [3:0]   wstrb,
    output logic         wlast,
    output logic         wvalid,
    input  logic         wready,

    // ===== AXI WRITE RESPONSE =====
    input  logic         bvalid,
    output logic         bready,

    // ===== AXI READ ADDRESS =====
    output logic [31:0]  araddr,
    output logic [2:0]   arsize,
    output logic [1:0]   arburst,
    output logic [3:0]   arlen,
    output logic         arvalid,
    input  logic         arready,

    // ===== AXI READ DATA =====
    input  logic [31:0]  rdata,
    input  logic         rvalid,
    input  logic         rlast,
    output logic         rready
);

    // -----------------------------
    // Fixed AXI parameters
    // -----------------------------
    assign awsize  = 3'b010; // 4 bytes
    assign arsize  = 3'b010;
    assign awburst = 2'b01;  // INCR
    assign arburst = 2'b01;
    assign awlen   = 4'd0;   // single beat
    assign arlen   = 4'd0;

    assign wlast   = 1'b1;

    // -----------------------------
    // Address translation
    // -----------------------------
    wire [31:0] phys_addr = i_req_addr - CORE_BASE + PHYS_BASE;

    // -----------------------------
    // FSM
    // -----------------------------
    typedef enum logic [2:0] {
        IDLE,
        W_AW,
        W_W,
        W_B,
        R_AR,
        R_R
    } state_t;

    state_t state, next;

    wire is_write = (i_req_wmask != 0);
    wire is_read  = !is_write;

    // -----------------------------
    // Sequential
    // -----------------------------
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next;
    end

    // -----------------------------
    // Combinational
    // -----------------------------
    always_comb begin
        // defaults
        next         = state;
        awvalid      = 0;
        wvalid       = 0;
        arvalid      = 0;
        bready       = 0;
        rready       = 0;

        o_req_ready  = 0;
        o_resp_valid = 0;

        case (state)

            IDLE: begin
                o_req_ready = 1;
                if (i_req_valid) begin
                    if (is_write)
                        next = W_AW;
                    else
                        next = R_AR;
                end
            end

            // -------- WRITE --------
            W_AW: begin
                awvalid = 1;
                if (awready)
                    next = W_W;
            end

            W_W: begin
                wvalid = 1;
                if (wready)
                    next = W_B;
            end

            W_B: begin
                bready = i_resp_ready;
                o_resp_valid = bvalid;
                if (bvalid && i_resp_ready)
                    next = IDLE;
            end

            // -------- READ --------
            R_AR: begin
                arvalid = 1;
                if (arready)
                    next = R_R;
            end

            R_R: begin
                rready = i_resp_ready;
                o_resp_valid = rvalid;
                if (rvalid && i_resp_ready)
                    next = IDLE;
            end

        endcase
    end

    // -----------------------------
    // Data signals
    // -----------------------------
    assign awaddr = phys_addr;
    assign araddr = phys_addr;

    assign wdata  = i_req_wdata;
    assign wstrb  = i_req_wmask;

    assign o_resp_rdata = rdata;

endmodule
/* verilator lint_on CASEINCOMPLETE */
