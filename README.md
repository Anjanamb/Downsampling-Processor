# Downsampling Processor

> A Verilog-based custom processor that performs low-pass filtering and downsampling (factor 2) of images, verified against Python-generated reference images using SSD (Sum of Squared Differences).

---

## Table of contents

- [Overview](#overview)  
- [Quickstart](#quickstart)  
- [Prerequisites](#prerequisites)  
- [Project structure](#project-structure)  
- [Workflow](#workflow)  
- [Simulation (Vivado/Icarus example)](#simulation-vivadoicarus-example)  
- [Evaluating results](#evaluating-results)  
- [Notes on filtering & implementation](#notes-on-filtering--implementation)  
- [Suggested improvements](#suggested-improvements)  
- [License & Credits](#license--credits)

---

## Overview

This repository contains the design and verification flow of a **Downsampling Processor** implemented in Verilog (Vivado project).  
The processor applies a filtering operation before performing **decimation by 2** (downsampling).  
To verify correctness, the downsampled output from hardware simulation is compared against a Python-generated reference using **Sum of Squared Differences (SSD)**.

This project was completed as part of **EN3030 (Circuits and Systems Design)** coursework.

---

## Quickstart

1. Clone the repository:
```bash
git clone https://github.com/Anjanamb/Downsampling-Processor.git
cd Downsampling-Processor
```

2. Generate input stimulus from an image (`Img generator/Img_gen.py`).  
3. Simulate the processor using Verilog RTL (`Processor/SRC/`).  
4. Convert simulation output back into an image (`Img conversion/Conversion.py`).  
5. Compute SSD error between hardware output and Python downsample (`Error calculation/SSD error.py`).

---

## Prerequisites

- **Verilog simulation / synthesis tool:**  
  - Xilinx Vivado (preferred, project already included under `Processor/`)  
  - OR Icarus Verilog (lightweight alternative, manual setup needed)
- **Python 3.8+** with libraries:
  - `numpy`
  - `Pillow`
  - `matplotlib` (optional, for visualization)

Install Python packages with:
```bash
pip install numpy pillow matplotlib
```

---

## Project structure

```
Downsampling-Processor/
├─ Compiler/             # Assembly/hex compiler helpers
│  ├─ compiler.py
│  ├─ Assembly code.txt
│  └─ hexfile.txt
│
├─ Error calculation/    # Compare hardware vs Python reference
│  ├─ SSD error.py
│  ├─ img_in.jpg
│  └─ output.txt
│
├─ Img conversion/       # Convert simulation results into image
│  ├─ Conversion.py
│  ├─ img.jpg
│  └─ imgdata.txt
│
├─ Img generator/        # Generate input test images / vectors
│  ├─ Img_gen.py
│  ├─ 128img.png
│  ├─ img.jpg
│  └─ output.txt
│
├─ Processor/            # Vivado project and Verilog RTL (SRC/)
│  ├─ Processor.xpr
│  ├─ SRC/ ...
│  └─ (Vivado project files)
│
└─ README.md
```

---

## Workflow

1. **Generate input image vectors**
```bash
cd "Img generator"
python Img_gen.py
```
This produces `output.txt` containing pixel data suitable as testbench input.

2. **Simulate processor**
- Open `Processor/Processor.xpr` in Vivado, run behavioral simulation.  
- OR use Icarus (if you extract Verilog files from `SRC/`).

3. **Convert simulation output**
```bash
cd "../Img conversion"
python Conversion.py
```
This converts simulation dump (`imgdata.txt`) into an image (`img.jpg`).

4. **Compute SSD error**
```bash
cd "../Error calculation"
python "SSD error.py"
```
This compares the reconstructed image against a Python downsample reference (`img_in.jpg` → processed), printing the SSD result.

---

## Simulation (Vivado/Icarus example)

### Vivado
1. Open `Processor/Processor.xpr` in Vivado.  
2. Run **Simulation → Run Behavioral Simulation**.  
3. Export results to a `.txt` file for conversion.

### Icarus (manual)
```bash
mkdir -p build
iverilog -o build/downsampler.vvp Processor/SRC/*.v
vvp build/downsampler.vvp > build/sim_output.txt
```

---

## Evaluating results

The main evaluation metric is **SSD (Sum of Squared Differences)**:  
- Computed by `Error calculation/SSD error.py`.  
- Lower SSD = higher similarity.  
- Zero SSD → identical images.

Example:
```bash
python "Error calculation/SSD error.py"
# Output: SSD = <value>
```

---

## Notes on filtering & implementation

- The processor includes **low-pass filtering** before downsampling (anti-aliasing).  
- Arithmetic is likely **fixed-point** in Verilog, so small differences vs. Python floating-point output are expected.  
- Ensure the Python reference applies the same filter kernel & quantization for a fair SSD comparison.

---

## Suggested improvements

- Add a top-level `Makefile` or script to automate the full flow: generate → simulate → convert → evaluate.  
- Document kernel/filter coefficients used in hardware inside `README` or comments.  
- Add a minimal test (tiny 8×8 image) for CI automation.  
- Provide clearer output format spec in `Img conversion/Conversion.py`.

---

## License & Credits

- Author: **Anjana Bandara** (`Anjanamb`)  
- Course: **EN3030 — Circuits and Systems Design**  
- License: MIT 

---
