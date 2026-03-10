`timescale 1ns/1ps

module top(
    input  wire       i_clk,
    input  wire [1:0] sw,
    input  wire [3:0] btn,
    output wire [3:0] led,
    output wire [5:0] led_rgb,

    input  wire       uart0_rx,
    output wire       uart0_tx,

    input  wire       uart1_rx,
    output wire       uart1_tx,

    output wire [31:0] o_axi_awaddr,
    output wire [2:0]  o_axi_awsize,
    output wire [1:0]  o_axi_awburst,
    output wire [3:0]  o_axi_awlen,
    output wire        o_axi_awvalid,
    input  wire        i_axi_awready,

    output wire [31:0] o_axi_wdata,
    output wire [3:0]  o_axi_wstrb,
    output wire        o_axi_wlast,
    output wire        o_axi_wvalid,
    input  wire        i_axi_wready,

    input  wire        i_axi_bvalid,
    output wire        o_axi_bready,

    output wire [31:0] o_axi_araddr,
    output wire [2:0]  o_axi_arsize,
    output wire [1:0]  o_axi_arburst,
    output wire [3:0]  o_axi_arlen,
    output wire        o_axi_arvalid,
    input  wire        i_axi_arready,

    input  wire [31:0] i_axi_rdata,
    input  wire        i_axi_rvalid,
    input  wire        i_axi_rlast,
    output wire        o_axi_rready
);

    pynq_wrapper u_pynq_wrapper (
        .i_clk        (i_clk),
        .sw           (sw),
        .btn          (btn),
        .led          (led),
        .led_rgb      (led_rgb),
        .uart0_rx     (uart0_rx),
        .uart0_tx     (uart0_tx),
        .uart1_rx     (uart1_rx),
        .uart1_tx     (uart1_tx),
        .o_axi_awaddr (o_axi_awaddr),
        .o_axi_awsize (o_axi_awsize),
        .o_axi_awburst(o_axi_awburst),
        .o_axi_awlen  (o_axi_awlen),
        .o_axi_awvalid(o_axi_awvalid),
        .i_axi_awready(i_axi_awready),
        .o_axi_wdata  (o_axi_wdata),
        .o_axi_wstrb  (o_axi_wstrb),
        .o_axi_wlast  (o_axi_wlast),
        .o_axi_wvalid (o_axi_wvalid),
        .i_axi_wready (i_axi_wready),
        .i_axi_bvalid (i_axi_bvalid),
        .o_axi_bready (o_axi_bready),
        .o_axi_araddr (o_axi_araddr),
        .o_axi_arsize (o_axi_arsize),
        .o_axi_arburst(o_axi_arburst),
        .o_axi_arlen  (o_axi_arlen),
        .o_axi_arvalid(o_axi_arvalid),
        .i_axi_arready(i_axi_arready),
        .i_axi_rdata  (i_axi_rdata),
        .i_axi_rvalid (i_axi_rvalid),
        .i_axi_rlast  (i_axi_rlast),
        .o_axi_rready (o_axi_rready)
    );

endmodule