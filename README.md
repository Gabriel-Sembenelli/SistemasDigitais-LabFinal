# SistemasDigitais-LabFinal

## Compiling and running

1. **Analyze (Compile):**
Compile your design and testbench files. Order matters: compile dependencies before the files that use them.

```bash
ghdl -a design.vhd testbench.vhd

```

2. **Elaborate:**
Build the executable for your testbench. Replace `tb_entity` with the actual name of your testbench entity.

```bash
ghdl -e tb_entity

```

3. **Run and Export Waveform:**
Run the simulation and output a waveform file.

```bash
ghdl -r tb_entity --vcd=wave.vcd
# or
ghdl -r tb_entity --wave=wave.ghw

```

4. **View in GTKWave:**
Open the generated waveform file to inspect your signals.

```bash
gtkwave wave.vcd
# or
gtkwave wave.ghw
```
