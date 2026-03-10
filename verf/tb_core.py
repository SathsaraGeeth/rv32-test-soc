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
        req_valid = int(dut.o_req_valid.value)
        req_addr  = int(dut.o_req_addr.value)
        wmask = int(dut.o_wmask.value)
        req_wdata = int(dut.o_req_wdata.value)
        resp_ready = int(dut.o_resp_ready.value)
        print(f"OUT: req_valid={req_valid} req_addr=0x{req_addr:08x} wmask=0x{wmask:x} req_wdata=0x{req_wdata:08x} resp_ready={resp_ready}")
        print(f"IN: req_ready={int(dut.i_req_ready.value)} resp_valid={int(dut.i_resp_valid.value)} resp_rdata=0x{int(dut.i_resp_rdata.value):08x}")

def inject_mem_port(dut, req_ready = 0, resp_valid = 0, resp_rdata = 0xFFFF_FFFF):
        dut.i_req_ready.value  = req_ready
        dut.i_resp_valid.value = resp_valid
        dut.i_resp_rdata.value = resp_rdata
        

@cocotb.test()
async def test(dut):
    cycle_ctr = [0]
    
    cocotb.start_soon(gen_clk(dut, 10))
    await reset(dut)

    inject_mem_port(dut)
    probe_mem_port(dut)
    await cycle(dut, cycle_ctr)

    inject_mem_port(dut)
    probe_mem_port(dut)
    await cycle(dut, cycle_ctr)

    inject_mem_port(dut)
    probe_mem_port(dut)
    await cycle(dut, cycle_ctr)

    inject_mem_port(dut, req_ready = 1, resp_valid = 0, resp_rdata = 9922)
    probe_mem_port(dut)
    await cycle(dut, cycle_ctr)

    inject_mem_port(dut, req_ready = 1, resp_valid = 0, resp_rdata = 99228)
    probe_mem_port(dut)
    await cycle(dut, cycle_ctr)

    inject_mem_port(dut, req_ready = 1, resp_valid = 0, resp_rdata = 997622)
    probe_mem_port(dut)
    await cycle(dut, cycle_ctr)

    inject_mem_port(dut, req_ready = 1, resp_valid = 1, resp_rdata = 0x00500113)
    probe_mem_port(dut)
    await cycle(dut, cycle_ctr)

    inject_mem_port(dut)
    probe_mem_port(dut)
    await cycle(dut, cycle_ctr)

    inject_mem_port(dut)
    probe_mem_port(dut)
    await cycle(dut, cycle_ctr)

    inject_mem_port(dut)
    probe_mem_port(dut)
    await cycle(dut, cycle_ctr)

    inject_mem_port(dut)
    probe_mem_port(dut)
    await cycle(dut, cycle_ctr)

    inject_mem_port(dut, req_ready = 1, resp_valid = 0)
    probe_mem_port(dut)
    await cycle(dut, cycle_ctr)

    inject_mem_port(dut, req_ready = 1, resp_valid = 1, resp_rdata = 0x00C00193)
    probe_mem_port(dut)
    await cycle(dut, cycle_ctr)

    inject_mem_port(dut)
    probe_mem_port(dut)
    await cycle(dut, cycle_ctr)

    inject_mem_port(dut)
    probe_mem_port(dut)
    await cycle(dut, cycle_ctr)

    inject_mem_port(dut)
    probe_mem_port(dut)
    await cycle(dut, cycle_ctr)

    inject_mem_port(dut)
    probe_mem_port(dut)
    await cycle(dut, cycle_ctr)

    inject_mem_port(dut)
    probe_mem_port(dut)
    await cycle(dut, cycle_ctr)

    inject_mem_port(dut)
    probe_mem_port(dut)
    await cycle(dut, cycle_ctr)






def run():
    sim = os.getenv("SIM", "verilator")
    project_dir = Path(__file__).parent.parent/"rtl"
    sources = [
        project_dir / "core.sv"
    ]
    runner = get_runner(sim)
    runner.build(
        sources=sources,
        hdl_toplevel="core",
        always=True,
    )
    runner.test(
        hdl_toplevel="core",
        test_module="tb_core",
    )
if __name__ == "__main__":
    run()