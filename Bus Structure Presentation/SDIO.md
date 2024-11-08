# Secure Digital Input Output
## Key Points of SDIO Communication
1-Bit Mode: This mode uses a single data line, making it simpler but slower. It is typically used in situations where fewer pins are available or lower speeds are sufficient.
4-Bit Mode: This mode uses four data lines, significantly increasing data throughput. Most SDIO applications, especially those requiring higher performance, use this mode.
In addition to data lines, the SDIO interface also requires:

Clock Line (CLK): Synchronizes data transmission.
Command Line (CMD): Used for sending commands and receiving responses between the host and the SDIO device.

## Outline
- Application Area
    - HW, SW, Common industry
- Bandwidth and Clock Rate

# Assigned to me
- Signaling Tech
    Bus has a clock, command, and 4-bit data bus-wide.
    - Clock 
    - CMD
    - Data line
- Signal Voltage

- Number of devices supported
- Number of signals required
- Topology