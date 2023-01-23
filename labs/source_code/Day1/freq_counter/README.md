# A Frequency Counter that measures an unknown clock and print to UART

Source code is available [here](https://github.com/BerkeleyLab/Bedrock/tree/master/homeless/freq_demo).

# Simulation
Single channel:
```bash
make freq_count.vcd
```

Multichannel:
```bash
make freq_demo_tb
```

# Synthesize
```bash
make freq_demo_top.bit
```

# FPGA configuration
```bash
make config_arty_freq
```

# Test
Open a UART terminal (baud rate 9600,8,N,1):
```bash
pyserial-miniterm /dev/ttyUSB0
```
where `ttyUSB0` assumes there is only one board connected.

Expected results:
```
--- Quit: Ctrl+] | Menu: Ctrl+T | Help: Ctrl+T followed by Ctrl+H ---

     Channel 1:  000.00000 MHz
     Channel 2:  000.00000 MHz
     Channel 3:  000.00000 MHz
     Channel 0:  099.99999 MHz
```

