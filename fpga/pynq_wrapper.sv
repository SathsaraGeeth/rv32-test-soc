`timescale 1ns/1ps

module pynq_wrapper (
    input  logic       i_clk,
    input  logic [1:0] sw,
    input  logic [3:0] btn,
    output logic [3:0] led,
    output logic [5:0] led_rgb,

    input  logic       uart0_rx,
    output logic       uart0_tx,

    input  logic       uart1_rx,
    output logic       uart1_tx,

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
    logic [31:0] gpio_in;
    logic [31:0] gpio_out;



    logic [3:0] btn_db;
    debounce #(
        .WIDTH(4),
        .CNT_MAX(16'hFFFF)
    ) db_inst (
        .i_clk   (i_clk),
        .i_btn   (btn),
        .o_btn   (btn_db)
    );

    logic i_rst_n;
    assign i_rst_n = btn_db[3];

    assign gpio_in[0] = sw[0];
    assign gpio_in[1] = sw[1];
    assign gpio_in[2] = btn_db[0];
    assign gpio_in[3] = btn_db[1];
    assign gpio_in[4] = btn_db[2];
    assign gpio_in[31:5] = 25'b0;

    assign led[0] = gpio_out[5];
    assign led[1] = gpio_out[6];
    assign led[2] = gpio_out[7];
    assign led_rgb[0] = gpio_out[8];
    assign led_rgb[1] = gpio_out[9];
    assign led_rgb[2] = gpio_out[10];
    assign led_rgb[3] = gpio_out[11];
    assign led_rgb[4] = gpio_out[12];
    assign led_rgb[5] = gpio_out[13];
    

    always_ff @(posedge i_clk) begin
        if (!i_rst_n) begin
            led[3] <= 1'b0;
        end else begin
            led[3] <= 1'b1;
        end
    end

    soc soc_inst (
        .i_clk       (i_clk),
        .i_rst_n     (i_rst_n),

        .i_uart0_rx(uart0_rx),
        .o_uart0_tx(uart0_tx),

        .i_uart1_rx(uart1_rx),
        .o_uart1_tx(uart1_tx),

        .i_gpio_bank0(gpio_in),
        .o_gpio_bank0(gpio_out),

        .o_axi_awaddr(o_axi_awaddr),
        .o_axi_awsize(o_axi_awsize),
        .o_axi_awburst(o_axi_awburst),
        .o_axi_awlen(o_axi_awlen),
        .o_axi_awvalid(o_axi_awvalid),
        .i_axi_awready(i_axi_awready),

        .o_axi_wdata(o_axi_wdata),
        .o_axi_wstrb(o_axi_wstrb),
        .o_axi_wlast(o_axi_wlast),
        .o_axi_wvalid(o_axi_wvalid),
        .i_axi_wready(i_axi_wready),

        .i_axi_bvalid(i_axi_bvalid),
        .o_axi_bready(o_axi_bready),

        .o_axi_araddr(o_axi_araddr),
        .o_axi_arsize(o_axi_arsize),
        .o_axi_arburst(o_axi_arburst),
        .o_axi_arlen(o_axi_arlen),
        .o_axi_arvalid(o_axi_arvalid),
        .i_axi_arready(i_axi_arready),

        .i_axi_rdata(i_axi_rdata),
        .i_axi_rvalid(i_axi_rvalid),
        .i_axi_rlast(i_axi_rlast),
        .o_axi_rready(o_axi_rready)
    );
endmodule

module debounce #(
    parameter WIDTH = 1,
    parameter CNT_MAX = 16'hFFFF
)(
    input  logic              i_clk,
    input  logic [WIDTH-1:0]  i_btn,
    output logic [WIDTH-1:0]  o_btn
);
    logic [15:0] cnt [WIDTH-1:0];

    always_ff @(posedge i_clk) begin
        for (int i = 0; i < WIDTH; i++) begin
            if (i_btn[i]) begin
                cnt[i] <= CNT_MAX;
            end else if (cnt[i] != 16'h0000) begin
                cnt[i] <= cnt[i] - 1;
            end
        end
    end
    always_comb begin
        for (int i = 0; i < WIDTH; i++) begin
            o_btn[i] = (cnt[i] == 16'h0000);
        end
    end
endmodule
