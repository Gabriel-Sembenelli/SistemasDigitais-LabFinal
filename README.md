# SistemasDigitais-LabFinal

## Compiling and running

1. **Analyze (Compile):**
Order matters: compile dependencies before the files that use them.

```bash
ghdl -a fp_adder.vhd fp_adder_testbench.vhd

```

1. **Elaborate:**
Build the executable for your testbench.

```bash
ghdl -e fp_adder_tb

```

1. **Run and Export Waveform:**
Run the simulation and output a waveform file.

```bash
ghdl -r fp_adder_tb --vcd=wave.vcd
# or
ghdl -r fp_adder_tb --wave=wave.ghw

```

4. **View in GTKWave:**
Open the generated waveform file to inspect your signals.

```bash
gtkwave wave.vcd
# or
gtkwave wave.ghw
```

**All in One**

```bash
ghdl -a fp_adder.vhd fp_adder_testbench.vhd && ghdl -e fp_adder_tb && ghdl -r fp_adder_tb --vcd=wave.vcd && gtkwave wave.vcd
```