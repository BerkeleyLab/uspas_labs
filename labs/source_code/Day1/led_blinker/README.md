# Lab Session Description
## Tasks
1. RTL design and verification
   1. Get familiar with GNU [make](https://www.gnu.org/software/make/) using `Makefile`s;
   2. Write a simple LED blinker in `verilog`;
   3. Write behavioral test bench;
   4. Build test bench and run simulation;
   5. Examine waveforms and understand logic behavior;
2. Synthesize the design
   1. Understand the synthesizing process;
   2. Write a `vivado` tcl script to define the process;
   3. Write position constraint file;
   4. Write timing constraint file;
   5. Execute synthesize, observe timing and utilization report;
3. Test on hardware
   1. Program the bitstream file on an FPGA device;
   2. Observe the LED blinker behavior and compare with simulation;

## Process
1. Build test bench
   ```
   make led_test_tb
   ```
2. Run behavioral simulation and build waveform
   ```
   make led_test.vcd
   ```
3. Examine waveform
   ```
   make led_test_view
   ```
   Note this won't work on a MacOS, where one need to manually launch `gtkwave` app, unless an additional command line tool is [installed](https://formulae.brew.sh/cask/gtkwave).
4. Synthesize:
   * for Arty A7
      ```
      make arty_led_top.bit
      ```
   * for Marble
      ```
      make marble_led_top.bit
      ```
   Note this won't work on a MacOS, and needs to be executed on a host where `vivado` is available in `$PATH`.
5. Program bitstream file
   Connect your board and
   * for Arty A7
   ```
   make config_arty_led
   ```
   * for Marble
   ```
   make config_marble_led
   ```
6. Clean up
   ```
   make clean
   ```

## Homework
Implement 4 dimmable LEDs using Pulse-Width Modulation, explain brightness;
