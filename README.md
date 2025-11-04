# 🧠 Dual-Port 32x32 RAM in Verilog

## 📘 Overview

This project implements a **Dual-Port RAM (32 words × 32 bits each)** in **Verilog HDL**.
It supports **simultaneous read/write** operations from two independent ports (A and B), each with its own address, data, and control signals.

The design is tested using a comprehensive **testbench** that verifies:

* Individual **write** operations
* Individual **read** operations
* **Simultaneous read/write** on different ports
* **Reset behavior** (clearing memory and outputs)

---

## ⚙️ Features

* **Two independent ports (A and B)**

  * Each has separate address, data, and enable controls.
* **Synchronous operations**

  * All reads/writes occur on the **positive edge** of the clock.
* **Reset mechanism**

  * Clears memory and output registers to zero for clean startup.
* **FPGA-synthesizable**

  * Avoids internal tri-states; uses `0` instead of `Z` when inactive.

---

## 🧩 Module Description

### `ram32.v`

Implements the dual-port memory.

**Ports:**

| Port                       | Direction | Width  | Description                     |
| -------------------------- | --------- | ------ | ------------------------------- |
| `clk`                      | Input     | 1-bit  | System clock                    |
| `reset`                    | Input     | 1-bit  | Synchronous reset (active high) |
| `addr_a`, `addr_b`         | Input     | 5-bit  | Address for Port A and Port B   |
| `data_in_a`, `data_in_b`   | Input     | 32-bit | Data input for each port        |
| `we_a`, `we_b`             | Input     | 1-bit  | Write enable for Port A and B   |
| `re_a`, `re_b`             | Input     | 1-bit  | Read enable for Port A and B    |
| `data_out_a`, `data_out_b` | Output    | 32-bit | Data output for each port       |

**Behavior Summary:**

* On `posedge clk`:

  * If `we_x = 1` → write data to memory.
  * Else if `re_x = 1` → read data from memory.
  * Else → output `0`.
* On `reset = 1` → clear all memory and outputs to `0`.

---

### `tb_ram32.v`

Testbench for verifying all operations.

**Key Simulation Stages:**

1. **Reset Phase:** Initialize memory and outputs.
2. **Write Phase:** Write sample data to multiple addresses through both ports.
3. **Read Phase:** Verify correct data retrieval.
4. **Simultaneous Access Phase:** Test parallel read/write on different addresses.
5. **Result Display:** Monitor textual and waveform output.


---

## 🧮 Design Decisions

* **`data_out` initialized to 0** → predictable synthesis and waveform behavior.
* **Synchronous reset** → avoids metastability at power-on.
* **No 'bz' or internal tri-states** → fully FPGA-compatible design.
* **Separate control for A/B** → parallel access improves throughput.

---



## 🧰 Tools Used

* **Language:** Verilog HDL
* **Simulator:** Vivado / Modelsim / Icarus Verilog
* **Target:** FPGA / ASIC compatible

---
