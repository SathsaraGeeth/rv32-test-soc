`timescale 1ns/1ps
module soc (
    input  logic i_clk,
    input  logic i_rst_n,

    // uart0
    input  logic        i_uart0_rx,
    output logic        o_uart0_tx,

    // uart1
    input  logic        i_uart1_rx,
    output logic        o_uart1_tx,

    // gpio0
    input  logic [31:0] i_gpio_bank0,
    output logic [31:0] o_gpio_bank0,

    // dram
    output logic [31:0] o_axi_awaddr,
    output logic [2:0]  o_axi_awsize,
    output logic [1:0]  o_axi_awburst,
    output logic [3:0]  o_axi_awlen,
    output logic        o_axi_awvalid,
    input  logic        i_axi_awready,

    output logic [31:0] o_axi_wdata,
    output logic [3:0]  o_axi_wstrb,
    output logic        o_axi_wlast,
    output logic        o_axi_wvalid,
    input  logic        i_axi_wready,

    input  logic        i_axi_bvalid,
    output logic        o_axi_bready,

    output logic [31:0] o_axi_araddr,
    output logic [2:0]  o_axi_arsize,
    output logic [1:0]  o_axi_arburst,
    output logic [3:0]  o_axi_arlen,
    output logic        o_axi_arvalid,
    input  logic        i_axi_arready,

    input  logic [31:0] i_axi_rdata,
    input  logic        i_axi_rvalid,
    input  logic        i_axi_rlast,
    output logic        o_axi_rready
);

    logic        w_m_req_valid;
    logic        w_m_req_ready;
    logic [31:0] w_m_req_addr;
    logic [3:0]  w_m_req_wmask;
    logic [31:0] w_m_req_wdata;
    logic        w_m_resp_valid;
    logic        w_m_resp_ready;
    logic [31:0] w_m_resp_rdata;

    logic        w_s0_req_valid;
    logic        w_s0_req_ready;
    logic [31:0] w_s0_req_addr;
    logic [3:0]  w_s0_req_wmask;
    logic [31:0] w_s0_req_wdata;
    logic        w_s0_resp_valid;
    logic        w_s0_resp_ready;
    logic [31:0] w_s0_resp_rdata;

    logic        w_s1_req_valid;
    logic        w_s1_req_ready;
    logic [31:0] w_s1_req_addr;
    logic [3:0]  w_s1_req_wmask;
    logic [31:0] w_s1_req_wdata;
    logic        w_s1_resp_valid;
    logic        w_s1_resp_ready;
    logic [31:0] w_s1_resp_rdata;

    logic        w_s2_req_valid;
    logic        w_s2_req_ready;
    logic [31:0] w_s2_req_addr;
    logic [3:0]  w_s2_req_wmask;
    logic [31:0] w_s2_req_wdata;
    logic        w_s2_resp_valid;
    logic        w_s2_resp_ready;
    logic [31:0] w_s2_resp_rdata;

    logic        w_s3_req_valid;
    logic        w_s3_req_ready;
    logic [31:0] w_s3_req_addr;
    logic [3:0]  w_s3_req_wmask;
    logic [31:0] w_s3_req_wdata;
    logic        w_s3_resp_valid;
    logic        w_s3_resp_ready;
    logic [31:0] w_s3_resp_rdata;

    logic        w_s4_req_valid;
    logic        w_s4_req_ready;
    logic [31:0] w_s4_req_addr;
    logic [3:0]  w_s4_req_wmask;
    logic [31:0] w_s4_req_wdata;
    logic        w_s4_resp_valid;
    logic        w_s4_resp_ready;
    logic [31:0] w_s4_resp_rdata;

    logic        w_s5_req_valid;
    logic        w_s5_req_ready;
    logic [31:0] w_s5_req_addr;
    logic [3:0]  w_s5_req_wmask;
    logic [31:0] w_s5_req_wdata;
    logic        w_s5_resp_valid;
    logic        w_s5_resp_ready;
    logic [31:0] w_s5_resp_rdata;



    // CORES
    parameter RESET_VECTOR_CORE0 = 32'h0000_0000;
    core #(
        .PROGADDR_RESET(RESET_VECTOR_CORE0)
    ) core0 (
        .i_clk        (i_clk),
        .i_rst_n      (i_rst_n),

        .o_req_valid  (w_m_req_valid),
        .i_req_ready  (w_m_req_ready),
        .o_req_addr   (w_m_req_addr),
        .o_req_wmask  (w_m_req_wmask),
        .o_req_wdata  (w_m_req_wdata),

        .i_resp_valid (w_m_resp_valid),
        .o_resp_ready (w_m_resp_ready),
        .i_resp_rdata (w_m_resp_rdata)
    );

    // ROM
    localparam ROM_DEPTH      = 1024;
    rom #(
        .BASE_ADDR(RESET_VECTOR_CORE0),
        .MEM_DEPTH(ROM_DEPTH)
    ) rom0 (
        .i_clk        (i_clk),
        .i_rst_n      (i_rst_n),

        .i_req_valid  (w_s0_req_valid),
        .o_req_ready  (w_s0_req_ready),
        .i_req_addr   (w_s0_req_addr),
        .i_req_wmask  (w_s0_req_wmask),
        .i_req_wdata  (w_s0_req_wdata),

        .o_resp_valid (w_s0_resp_valid),
        .i_resp_ready (w_s0_resp_ready),
        .o_resp_rdata (w_s0_resp_rdata)
    );

    // SPM
    localparam MEM_DEPTH_SPM0      = 16384;
    localparam SPM_BASE            = 32'h0000_1000;
    spm #(
        .BASE_ADDR(SPM_BASE),
        .MEM_DEPTH(MEM_DEPTH_SPM0)
    ) spm0 (
        .i_clk        (i_clk),
        .i_rst_n      (i_rst_n),

        .i_req_valid  (w_s1_req_valid),
        .o_req_ready  (w_s1_req_ready),
        .i_req_addr   (w_s1_req_addr),
        .i_req_wmask  (w_s1_req_wmask),
        .i_req_wdata  (w_s1_req_wdata),

        .o_resp_valid (w_s1_resp_valid),
        .i_resp_ready (w_s1_resp_ready),
        .o_resp_rdata (w_s1_resp_rdata)
    );

    // dram
    localparam  DRAM_BASE = 32'h0001_1000;
    dram_adp #(
        .CORE_BASE(DRAM_BASE),
        .PHYS_BASE(32'h0000_0000)
    ) dram0 (
        .clk        (i_clk),
        .rst_n      (i_rst_n),

        .i_req_valid(w_s2_req_valid),
        .o_req_ready(w_s2_req_ready),
        .i_req_addr (w_s2_req_addr),
        .i_req_wmask(w_s2_req_wmask),
        .i_req_wdata(w_s2_req_wdata),

        .o_resp_valid(w_s2_resp_valid),
        .i_resp_ready(w_s2_resp_ready),
        .o_resp_rdata(w_s2_resp_rdata),

        // Connect adapter AXI ports to SOC ports
        .awaddr     (o_axi_awaddr),
        .awsize     (o_axi_awsize),
        .awburst    (o_axi_awburst),
        .awlen      (o_axi_awlen),
        .awvalid    (o_axi_awvalid),
        .awready    (i_axi_awready),

        .wdata      (o_axi_wdata),
        .wstrb      (o_axi_wstrb),
        .wlast      (o_axi_wlast),
        .wvalid     (o_axi_wvalid),
        .wready     (i_axi_wready),

        .bvalid     (i_axi_bvalid),
        .bready     (o_axi_bready),

        .araddr     (o_axi_araddr),
        .arsize     (o_axi_arsize),
        .arburst    (o_axi_arburst),
        .arlen      (o_axi_arlen),
        .arvalid    (o_axi_arvalid),
        .arready    (i_axi_arready),

        .rdata      (i_axi_rdata),
        .rvalid     (i_axi_rvalid),
        .rlast      (i_axi_rlast),
        .rready     (o_axi_rready)
    );

    /* uart LOOPBACK TEST ON */
    // logic i_uart0_rx, o_uart0_tx;
    // assign i_uart0_rx = o_uart0_tx;
    /* uart LOOPBACK TEST OFF */

    // UART0
    localparam UART0_BASE = 32'h2000_1000;
    uart_mmio #(
        .BASE_ADDR(UART0_BASE),
        .RX_DEPTH(8),
        .TX_DEPTH(8)
    ) uart0 (
        .i_clk        (i_clk),
        .i_rst_n      (i_rst_n),
        .i_req_valid  (w_s3_req_valid),
        .o_req_ready  (w_s3_req_ready),
        .i_req_addr   (w_s3_req_addr),
        .i_req_wmask  (w_s3_req_wmask),
        .i_req_wdata  (w_s3_req_wdata),

        .o_resp_valid (w_s3_resp_valid),
        .i_resp_ready (w_s3_resp_ready),
        .o_resp_rdata (w_s3_resp_rdata),

        .i_rx(i_uart0_rx),
        .o_tx(o_uart0_tx)
    );

    // UART1
    localparam UART1_BASE = 32'h2001_1000;
    uart_mmio #(
        .BASE_ADDR(UART1_BASE),
        .RX_DEPTH(8),
        .TX_DEPTH(8)
    ) uart1 (
        .i_clk        (i_clk),
        .i_rst_n      (i_rst_n),
        .i_req_valid  (w_s4_req_valid),
        .o_req_ready  (w_s4_req_ready),
        .i_req_addr   (w_s4_req_addr),
        .i_req_wmask  (w_s4_req_wmask),
        .i_req_wdata  (w_s4_req_wdata),

        .o_resp_valid (w_s4_resp_valid),
        .i_resp_ready (w_s4_resp_ready),
        .o_resp_rdata (w_s4_resp_rdata),

        .i_rx(i_uart1_rx),
        .o_tx(o_uart1_tx)
    );


    // GPIO
    // GPIO_BANK0 - {18'b0, led_rgb[5], led_rgb[4], led_rgb[3], led_rgb[2], led_rgb[1], led_rgb[0], led[2], led[1], led[0], btn_db[2], btn_db[1], btn_db[0], sw[1], sw[0]}

    // RO = 32'b0000_0000_0000_0000_0000_0000_0001_1111
    // WO = 32'b0000_0000_0000_0000_0011_1111_1110_0000
    // RW = 32'b0000_0000_0000_0000_0000_0000_0000_0000
    // BASE_GPIO0 = 32'h2000_0000
    localparam  GPIO0_BASE = 32'h2002_1000;
    gpio_bank #(
        .BASE_ADDR(GPIO0_BASE),
        .RW_MASK(32'b0000_0000_0000_0000_0000_0000_0000_0000),
        .RO_MASK(32'b0000_0000_0000_0000_0000_0000_0001_1111),
        .WO_MASK(32'b0000_0000_0000_0000_0011_1111_1110_0000)
    ) gpio_bank0 (
        .i_clk        (i_clk),
        .i_rst_n      (i_rst_n),
        .i_req_valid  (w_s5_req_valid),
        .o_req_ready  (w_s5_req_ready),
        .i_req_addr   (w_s5_req_addr),
        .i_req_wmask  (w_s5_req_wmask),
        .i_req_wdata  (w_s5_req_wdata),

        .o_resp_valid (w_s5_resp_valid),
        .i_resp_ready (w_s5_resp_ready),
        .o_resp_rdata (w_s5_resp_rdata),

        .i_gpio_bank0 (i_gpio_bank0),
        .o_gpio_bank0 (o_gpio_bank0)
    );

    

    // Interconnect
    bus_interconnect bus_interconnect0 (
        .m_req_valid  (w_m_req_valid),
        .m_req_ready  (w_m_req_ready),
        .m_req_addr   (w_m_req_addr),
        .m_req_wmask  (w_m_req_wmask),
        .m_req_wdata  (w_m_req_wdata),
        .m_resp_valid (w_m_resp_valid),
        .m_resp_rdata (w_m_resp_rdata),
        .m_resp_ready (w_m_resp_ready),

        // Slave 0 (ROM)
        .s0_req_valid (w_s0_req_valid),
        .s0_req_ready (w_s0_req_ready),
        .s0_req_addr  (w_s0_req_addr),
        .s0_req_wmask (w_s0_req_wmask),
        .s0_req_wdata (w_s0_req_wdata),
        .s0_resp_valid(w_s0_resp_valid),
        .s0_resp_rdata(w_s0_resp_rdata),
        .s0_resp_ready(w_s0_resp_ready),

        // Slave 1 (SPM)
        .s1_req_valid (w_s1_req_valid),
        .s1_req_ready (w_s1_req_ready),
        .s1_req_addr  (w_s1_req_addr),
        .s1_req_wmask (w_s1_req_wmask),
        .s1_req_wdata (w_s1_req_wdata),
        .s1_resp_valid(w_s1_resp_valid),
        .s1_resp_rdata(w_s1_resp_rdata),
        .s1_resp_ready(w_s1_resp_ready),

        // Slave 2 (DRAM)
        .s2_req_valid (w_s2_req_valid),
        .s2_req_ready (w_s2_req_ready),
        .s2_req_addr  (w_s2_req_addr),
        .s2_req_wmask (w_s2_req_wmask),
        .s2_req_wdata (w_s2_req_wdata),
        .s2_resp_valid(w_s2_resp_valid),
        .s2_resp_rdata(w_s2_resp_rdata),
        .s2_resp_ready(w_s2_resp_ready),

        // Slave 3 (UART0)
        .s3_req_valid (w_s3_req_valid),
        .s3_req_ready (w_s3_req_ready),
        .s3_req_addr  (w_s3_req_addr),
        .s3_req_wmask (w_s3_req_wmask),
        .s3_req_wdata (w_s3_req_wdata),
        .s3_resp_valid(w_s3_resp_valid),
        .s3_resp_rdata(w_s3_resp_rdata),
        .s3_resp_ready(w_s3_resp_ready),

        // Slave 4 (UART1)
        .s4_req_valid (w_s4_req_valid),
        .s4_req_ready (w_s4_req_ready),
        .s4_req_addr  (w_s4_req_addr),
        .s4_req_wmask (w_s4_req_wmask),
        .s4_req_wdata (w_s4_req_wdata),
        .s4_resp_valid(w_s4_resp_valid),
        .s4_resp_rdata(w_s4_resp_rdata),
        .s4_resp_ready(w_s4_resp_ready),

        // Slave 5 (GPIO0)
        .s5_req_valid (w_s5_req_valid),
        .s5_req_ready (w_s5_req_ready),
        .s5_req_addr  (w_s5_req_addr),
        .s5_req_wmask (w_s5_req_wmask),
        .s5_req_wdata (w_s5_req_wdata),
        .s5_resp_valid(w_s5_resp_valid),
        .s5_resp_rdata(w_s5_resp_rdata),
        .s5_resp_ready(w_s5_resp_ready)
    );
endmodule   // soc - system on chip
