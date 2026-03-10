# tb.py
import cocotb
from cocotb.triggers import RisingEdge, Timer
from cocotb.clock import Clock
from cocotb_tools.runner import get_runner
from pathlib import Path
import os

async def gen_clk(dut, period_ns=10):
    while True:
        dut.i_clk.value = 0
        await Timer(period_ns/2, unit="ns")
        dut.i_clk.value = 1
        await Timer(period_ns/2, unit="ns")

async def reset(dut, cycles=2):
        dut.i_rst_n.value = 0
        for _ in range(cycles):
            await RisingEdge(dut.i_clk)
        dut.i_rst_n.value = 1
        await RisingEdge(dut.i_clk)

async def cycle(dut, cycle_ctr):
     cycle_ctr[0] += 1
     print("------------ Cycle:", cycle_ctr[0], "--------------")
     await RisingEdge(dut.i_clk)
     
     
def probe_mem_port(dut):
        req_valid = int(dut.core0.o_req_valid.value)
        req_addr  = int(dut.core0.o_req_addr.value)
        wmask = int(dut.core0.o_req_wmask.value)
        req_wdata = int(dut.core0.o_req_wdata.value)
        resp_ready = int(dut.core0.o_resp_ready.value)

        print(f"OUT: req_valid={req_valid} req_addr=0x{req_addr:08x} wmask=0x{wmask:x} req_wdata=0x{req_wdata:08x} resp_ready={resp_ready}")
        print(f"IN: req_ready={int(dut.core0.i_req_ready.value)} resp_valid={int(dut.core0.i_resp_valid.value)} resp_rdata=0x{int(dut.core0.i_resp_rdata.value):08x}")

        if int(dut.w_s0_resp_valid.value):
            print("spm transcation done.")
        if int(dut.w_s1_resp_valid.value):
            print("mmio transcation done.")
            
def dump_spm(dut):
    print("mem")
    items = [(i, mem.value) for i, mem in enumerate(dut.spm0.mem)]
    print({i: hex(val) for i, val in items})

def dump_gpio_o(dut):
    print("gpio_bank0")
    reg_val = int(dut.gpio_bank0.reg_data.value)
    items = [(i, (reg_val >> i) & 1) for i in range(32)]
    print(items)


@cocotb.test()
async def test(dut):
    cycle_ctr = [0]
    
    cocotb.start_soon(gen_clk(dut, 10))
    await reset(dut)

    i = 0
    while (i < 1000000):
        probe_mem_port(dut)
        await cycle(dut, cycle_ctr)

        # print("baud", dut.uart0.r_div.value)
        
        # print("rx:", dut.uart0.uart_inst.i_rx.value, "tx:", dut.uart0.uart_inst.o_tx.value)
        # print("rx_SAMP_CTR:", dut.uart0.uart_inst.samp_ctr.value)
        # print("txQ:", dut.uart0.uart_inst.tx_buffer.mem_buff.value)
        # print("rxQ:", dut.uart0.uart_inst.rx_buffer.mem_buff.value)
        # print("txQvalid:", dut.uart0.uart_inst.w_valid_tx.value)
        # print("txState:", dut.uart0.uart_inst.s_tx_state.value)
        # print("rxState:", dut.uart0.uart_inst.s_rx_state.value)
        # print("shfrx:", dut.uart0.uart_inst.r_rx_shft_reg.r_shft_reg.value, "shftx:", dut.uart0.uart_inst.r_tx_shft_reg.r_shft_reg.value)
        # print("level RX:", dut.uart0.w_rx_level.value)
        # print("level TX:", dut.uart0.w_tx_level.value)
        # print("rx_ready:",dut.uart0.w_rx_ready.value, "rx_valid:", dut.uart0.w_rx_valid.value)
        # print("tx_ready:",dut.uart0.w_tx_ready.value,  "tx_valid:", dut.uart0.w_tx_valid.value)
        # print("tx_data:", dut.uart0.w_tx_data.value, "rx_data:", dut.uart0.w_rx_data.value)

        # dump_gpio_o(dut)
        # i += 1

    # dump_spm(dut)


def run():
    sim = os.getenv("SIM", "verilator")
    project_dir = Path(__file__).parent.parent/"rtl"
    sources = [
        project_dir / "soc.sv",
        project_dir / "core.sv",
        project_dir / "spm.sv",
        project_dir / "gpio_bank.sv",
        project_dir / "bus_interconnect.sv",
        project_dir / "uart.sv",
        project_dir / "uart_mmio.sv",
        project_dir / "dram_adp.sv",
    ]
    runner = get_runner(sim)
    runner.build(
        sources=sources,
        hdl_toplevel="soc",
        always=True,
    )
    runner.test(
        hdl_toplevel="soc",
        test_module="tb_soc",
    )
if __name__ == "__main__":
    run()
