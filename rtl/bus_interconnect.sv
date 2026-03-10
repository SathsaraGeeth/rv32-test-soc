`timescale 1ns/1ps
module bus_interconnect (
    // master 0 (CORE 0)
    input  logic         m_req_valid,
    output logic         m_req_ready,
    input  logic [31:0]  m_req_addr,
    input  logic [3:0]   m_req_wmask,
    input  logic [31:0]  m_req_wdata,

    output logic         m_resp_valid,
    output logic [31:0]  m_resp_rdata,
    input  logic         m_resp_ready,

    // slave 0 (ROM)
    output logic         s0_req_valid,
    input  logic         s0_req_ready,
    output logic [31:0]  s0_req_addr,
    output logic [3:0]   s0_req_wmask,
    output logic [31:0]  s0_req_wdata,
    input  logic         s0_resp_valid,
    input  logic [31:0]  s0_resp_rdata,
    output logic         s0_resp_ready,
    
    // slave 1 (SPM)
    output logic         s1_req_valid,
    input  logic         s1_req_ready,
    output logic [31:0]  s1_req_addr,
    output logic [3:0]   s1_req_wmask,
    output logic [31:0]  s1_req_wdata,
    input  logic         s1_resp_valid,
    input  logic [31:0]  s1_resp_rdata,
    output logic         s1_resp_ready,

    // slave 2 (DRAM- cached)
    output logic         s2_req_valid,
    input  logic         s2_req_ready,
    output logic [31:0]  s2_req_addr,
    output logic [3:0]   s2_req_wmask,
    output logic [31:0]  s2_req_wdata,
    input  logic         s2_resp_valid,
    input  logic [31:0]  s2_resp_rdata,
    output logic         s2_resp_ready,

    // slave 3 (UART0)
    output logic         s3_req_valid,
    input  logic         s3_req_ready,
    output logic [31:0]  s3_req_addr,
    output logic [3:0]   s3_req_wmask,
    output logic [31:0]  s3_req_wdata,
    input  logic         s3_resp_valid,
    input  logic [31:0]  s3_resp_rdata,
    output logic         s3_resp_ready,

    // slave 4 (UART1)
    output logic         s4_req_valid,
    input  logic         s4_req_ready,
    output logic [31:0]  s4_req_addr,
    output logic [3:0]   s4_req_wmask,
    output logic [31:0]  s4_req_wdata,
    input  logic         s4_resp_valid,
    input  logic [31:0]  s4_resp_rdata,
    output logic         s4_resp_ready,

    // slave 5 (GPIO0)
    output logic         s5_req_valid,
    input  logic         s5_req_ready,
    output logic [31:0]  s5_req_addr,
    output logic [3:0]   s5_req_wmask,
    output logic [31:0]  s5_req_wdata,
    input  logic         s5_resp_valid,
    input  logic [31:0]  s5_resp_rdata,
    output logic         s5_resp_ready

);  
    logic sel_s0, sel_s1, sel_s2, sel_s3, sel_s4, sel_s5;
    // always_comb begin
    //     if      (m_req_addr >= 32'hA000_0000) begin sel_s0 = 0; sel_s1 = 0; sel_s2 = 0; sel_s3 = 1; end
    //     else if (m_req_addr >= 32'h3000_0000) begin sel_s0 = 0; sel_s1 = 0; sel_s2 = 1; sel_s3 = 0; end
    //     else if (m_req_addr >= 32'h2000_0000) begin sel_s0 = 0; sel_s1 = 1; sel_s2 = 0; sel_s3 = 0; end
    //     else if (m_req_addr <  32'h2000_0000) begin sel_s0 = 1; sel_s1 = 0; sel_s2 = 0; sel_s3 = 0; end
    //     else                                  begin sel_s0 = 0; sel_s1 = 0; sel_s2 = 0; sel_s3 = 0; $fatal("Out of the memory map."); end
    // end

    always_comb begin
        sel_s0 = 0; sel_s1 = 0; sel_s2 = 0;
        sel_s3 = 0; sel_s4 = 0; sel_s5 = 0;
        
        if      (m_req_addr >= 32'h2002_1000) sel_s5 = 1;           // GPIO0
        else if (m_req_addr >= 32'h2001_1000) sel_s4 = 1;           // UART1
        else if (m_req_addr >= 32'h2000_1000) sel_s3 = 1;           // UART0
        else if (m_req_addr >= 32'h0001_1000) sel_s2 = 1;           // DRAM
        else if (m_req_addr >= 32'h0000_1000) sel_s1 = 1;           // SPM
        else if (m_req_addr >= 32'h0000_0000) sel_s0 = 1;           // ROM
        else $fatal("Address out of memory map!");
    end

    assign s0_req_valid     = m_req_valid && sel_s0;
    assign s0_req_addr      = m_req_addr;
    assign s0_req_wmask     = m_req_wmask;
    assign s0_req_wdata     = m_req_wdata;
    assign s0_resp_ready    = m_resp_ready;

    assign s1_req_valid     = m_req_valid && sel_s1;
    assign s1_req_addr      = m_req_addr;
    assign s1_req_wmask     = m_req_wmask;
    assign s1_req_wdata     = m_req_wdata;
    assign s1_resp_ready    = m_resp_ready;

    assign s2_req_valid     = m_req_valid && sel_s2;
    assign s2_req_addr      = m_req_addr;
    assign s2_req_wmask     = m_req_wmask;
    assign s2_req_wdata     = m_req_wdata;
    assign s2_resp_ready    = m_resp_ready;

    assign s3_req_valid     = m_req_valid && sel_s3;
    assign s3_req_addr      = m_req_addr;
    assign s3_req_wmask     = m_req_wmask;
    assign s3_req_wdata     = m_req_wdata;
    assign s3_resp_ready    = m_resp_ready;

    assign s4_req_valid     = m_req_valid && sel_s4;
    assign s4_req_addr      = m_req_addr;
    assign s4_req_wmask     = m_req_wmask;
    assign s4_req_wdata     = m_req_wdata;
    assign s4_resp_ready    = m_resp_ready;

    assign s5_req_valid     = m_req_valid && sel_s5;
    assign s5_req_addr      = m_req_addr;
    assign s5_req_wmask     = m_req_wmask;
    assign s5_req_wdata     = m_req_wdata;
    assign s5_resp_ready    = m_resp_ready;

    assign m_req_ready  = sel_s0 ? s0_req_ready :
                          sel_s1 ? s1_req_ready :
                          sel_s2 ? s2_req_ready :
                          sel_s3 ? s3_req_ready :
                          sel_s4 ? s4_req_ready :
                          sel_s5 ? s5_req_ready : 1'b0;

    assign m_resp_valid = sel_s0 ? s0_resp_valid :
                          sel_s1 ? s1_resp_valid :
                          sel_s2 ? s2_resp_valid :
                          sel_s3 ? s3_resp_valid :
                          sel_s4 ? s4_resp_valid :
                          sel_s5 ? s5_resp_valid : 1'b0;

    assign m_resp_rdata = sel_s0 ? s0_resp_rdata :
                          sel_s1 ? s1_resp_rdata :
                          sel_s2 ? s2_resp_rdata : 
                          sel_s3 ? s3_resp_rdata :
                          sel_s4 ? s4_resp_rdata : 
                          sel_s5 ? s5_resp_rdata : 32'hDEADBEEF;

    always_comb begin
        if (m_req_valid) begin
            if ((sel_s0 + sel_s1 + sel_s2 + sel_s3 + sel_s4 + sel_s5) > 1) begin
                $display("[ERROR] Addr 0x%08x selected multiple slaves!", m_req_addr);
                $fatal;
            end else if (sel_s0) begin
                $display("[BUS] %0t: addr 0x%08x routed to ROM", $time, m_req_addr);
            end else if (sel_s1) begin
                $display("[BUS] %0t: addr 0x%08x routed to SPM", $time, m_req_addr);
            end else if (sel_s2) begin
                $display("[BUS] %0t: addr 0x%08x routed to DRAM", $time, m_req_addr);
            end else if (sel_s3) begin
                $display("[BUS] %0t: addr 0x%08x routed to UART0", $time, m_req_addr);
            end else if (sel_s4) begin
                $display("[BUS] %0t: addr 0x%08x routed to UART1", $time, m_req_addr);
            end else if (sel_s5) begin
                $display("[BUS] %0t: addr 0x%08x routed to GPIO0", $time, m_req_addr);
            end else begin
                $display("[BUS] %0t: addr 0x%08x hits NO slave!", $time, m_req_addr);
                $fatal;
            end
        end
    end
endmodule
