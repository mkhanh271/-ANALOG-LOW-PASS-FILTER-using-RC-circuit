# Design of Analog Low-Pass Filter using RC Circuit

> A two-stage **analog low-pass filter** designed with a **Sallen-Key active topology** (Stage 1) cascaded with a **passive RC + non-inverting amplifier** (Stage 2), targeting a **−3 dB cutoff at 20 kHz**. The circuit is simulated in **Proteus** and analyzed mathematically in **MATLAB**.

---
## This is my group project , everything is optimized and good to run , good luck !

## 📋 Table of Contents

- [Overview](#overview)
- [Circuit Design](#circuit-design)
- [Transfer Functions](#transfer-functions)
- [Component Values](#component-values)
- [Frequency Response](#frequency-response)
- [Simulation: Proteus](#simulation-proteus)
- [Analysis: MATLAB](#analysis-matlab)
- [References](#references)

---

## Overview

| Property | Value |
|---|---|
| Filter type | Low-Pass Filter (LPF) |
| Topology | 2-stage: Sallen-Key + Passive RC with amplifier |
| Target cutoff (−3 dB) | **20 kHz** |
| Stage 1 | 2nd-order Sallen-Key active LPF |
| Stage 2 | 1st-order passive RC + non-inverting op-amp |
| Total order | 3rd-order |
| Simulation tool | Proteus (`LPF.pdsprj`) |
| Analysis tool | MATLAB (`lpf.m`) |

---

## Circuit Design

### Overall Block Diagram

```
 Vin
  │
  ▼
┌──────────────────┐        ┌──────────────────────────────┐
│    Stage 1       │        │           Stage 2            │
│  Sallen-Key LPF  │──────► │  Passive RC + Non-Inv. Amp   │──► Vout
│  (2nd-order)     │  U1    │  (1st-order + Gain)          │  U2
└──────────────────┘        └──────────────────────────────┘
   Green trace                      Red trace
```

---

### Stage 1 — Sallen-Key Low-Pass Filter (2nd Order)

The Sallen-Key topology is a classic active filter using a single op-amp, providing a 2nd-order response with no inductors.

```
         R1              R2
Vin ────/\/\/────┬────/\/\/────┬──── U1(+) ────► U1 Output
                 │             │
                C1            C2
                 │             │
                GND           GND
                
U1(-) connected to U1 Output (unity gain / voltage follower)
```

**Transfer function (normalized):**

$$H_1(s) = \frac{1}{s^2 R_1 R_2 C_1 C_2 + s C_2 (R_1 + R_2) + 1}$$

---

### Stage 2 — Passive RC + Non-Inverting Amplifier (1st Order)

A simple RC low-pass feeds into a non-inverting op-amp configured for fixed gain.

```
          R3
U1 ────/\/\/────┬──── U2(+)
                │
               C3         U2(-) ──┬── RG1 ──► GND
                │                 │
               GND               R4
                             U2 Output ──┴──► Vout
```

**Stage 2 gain:**

$$A_{v2} = 1 + \frac{R_{G1}}{R_4} = 1 + \frac{1500}{2000} = 1.75 \quad (\approx +4.86\,\text{dB})$$

**Transfer function:**

$$H_2(s) = \frac{A_{v2}}{s R_3 C_3 + 1}$$

---

## Transfer Functions

**Total system transfer function:**

$$H_{total}(s) = H_1(s) \times H_2(s) = \frac{A_{v2}}{\left(s^2 R_1 R_2 C_1 C_2 + s C_2(R_1 + R_2) + 1\right) \cdot (s R_3 C_3 + 1)}$$

The MATLAB plot normalizes the total response by subtracting the DC gain, so both curves start at **0 dB** at low frequencies for easy comparison.

---

## Component Values

### Stage 1 — Sallen-Key LPF

| Component | Value | Notes |
|-----------|-------|-------|
| R1 | **7,725 Ω** | Tuned from 8,200 Ω to hit exactly −3 dB at 20 kHz |
| R2 | 800 Ω | |
| C1 | 1 nF | |
| C2 | 1 nF | |

### Stage 2 — Passive RC + Amplifier

| Component | Value | Notes |
|-----------|-------|-------|
| R3 | 1,000 Ω | Kept low to avoid adding excessive filtering |
| C3 | 1 nF | |
| RG1 | 1,500 Ω | Gain-setting resistor |
| R4 | 2,000 Ω | Feedback resistor |

**Stage 2 gain:** 1 + (1500/2000) = **1.75× (+4.86 dB)**

---

## Frequency Response

### Target Performance

| Metric | Value |
|---|---|
| Cutoff frequency (−3 dB) | **20 kHz** |
| Gain at 20 kHz (normalized) | ≈ **−3.00 dB** |
| Roll-off rate | −60 dB/decade (3rd order) |
| Phase at 20 kHz | ≈ **−135°** |
| DC gain (Stage 2) | +4.86 dB (normalized to 0 dB in plots) |

### What the plots show

**Frequency Response (top panel):**
- **Green line** — U1 output: Stage 1 only (Sallen-Key, 2nd order, −40 dB/dec)
- **Red line** — U2 output: Full system normalized (3rd order, −60 dB/dec)
- **Red ×** marker at 20 kHz showing the exact −3 dB point

**Phase Response (bottom panel):**
- **Yellow line** — Total system phase
- Ranges from 0° at DC to approaching −270° at high frequency (3rd order)
- **Red ×** marker shows phase at 20 kHz

---

## Simulation: Proteus

The file `LPF.pdsprj` contains the full Proteus circuit schematic including:
- Both op-amp stages wired with the component values above
- AC sweep simulation configured from 10 Hz to 200 kHz
- Frequency response plot showing gain (dB) vs frequency

### How to open

1. Install **Proteus Design Suite** (version 8.x recommended)
2. Open `LPF.pdsprj`
3. Run **AC Sweep** simulation to view the Bode plot
4. Probe outputs at U1 and U2 to compare Stage 1 vs total response

---

## Analysis: MATLAB

`lpf.m` implements the full mathematical analysis using the Control System Toolbox.

### What the script does

```
1. Define component values (R1..R4, C1..C3, RG1)
2. Build transfer functions H1(s) and H_total(s) using tf()
3. Compute Bode magnitude and phase over 10 Hz – 200 kHz
4. Normalize total response by subtracting DC gain
5. Plot frequency response (top) and phase response (bottom)
6. Mark and annotate the 20 kHz operating point
```

### Run in MATLAB

```matlab
% Simply run:
lpf
```

No additional toolboxes required beyond the **Control System Toolbox** (for `tf()` and `bode()`).

### Output

A single figure with black background (Proteus-style) containing:
- Top panel: Gain (dB) vs Frequency — Stage 1 (green) and Total (red)
- Bottom panel: Phase (deg) vs Frequency — Total system (yellow)
- Annotations at 20 kHz for both gain and phase values

---

## References

- Sedra, A.S. & Smith, K.C. — *Microelectronic Circuits*, 7th ed., Oxford University Press
- Sallen, R.P. & Key, E.L. — *"A Practical Method of Designing RC Active Filters"*, IRE Transactions on Circuit Theory, 1955
- [Proteus Design Suite — Labcenter Electronics](https://www.labcenter.com/)
- [Sallen-Key Topology — Texas Instruments Application Note](https://www.ti.com/lit/an/sloa049d/sloa049d.pdf)

---

## License

MIT License — see [LICENSE](LICENSE) for details.
