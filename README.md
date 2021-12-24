# OVI40 DDC/DUC RF Board using Cyclone10LP FPGA

**The journey has begun!**

The idea was to develop a small but powerful SDR RX/TX synthesizer module for OVI40 UI PCB. The UI-PCB was inspired by legendary [mcHF made by Chris, M0NKA](http://m0nka.co.uk). This UI uses STM32F7 / H7 processor and interfaces to a LCD (standard 3.5" / 480x320), encoders / buttons, I2C / SPI busses and SAI for I/Q data transfer. It is running with [UHSDR](https://github.com/df8oe/UHSDR). Result is a direct sampling module which allows short wave and VHF/UHF/SHF working in "standalone" - included QO100 without the need of a computer or a transverter.
Inspiration (and starting point of FPGA firmware) was [N7DDCs "DDC2 module"](https://github.com/Dfinitski/DDC_Module_2)

### OVI40-RF1 (which was only an intermediate development state) is a 4 layer PCB inspired by DDC2 with this hardware specifications:
	- faster ADC (ADS4146 instead of AD9649)
	- FPGA with more elements inside (10CL016 instead of 10CL006)
This board was capable to work from 15KHz...76.8MHz (all amateur radio bands from 2200m...4m)

### OVI40-RF2 (the final board) is a 6 layer PCB and has the following hardware specifications:
	- two ADCs instead of one (for rx antenna diversity)
	- FPGA with more elements inside (10CL025 instead of 10CL016)
	- AD936x transceiver chip (works from 70MHz...6GHz)
	- additional RAM (64MBit)
	- additional USB interface chip (for adding large bandwidth capability for e.g. DATV)
	- possibility for feeding FPGA bit-files during runtime

#### Firmware support for OVI40-RF2 is under construction. Here you can see the state:

##### working:
	- RX 15KHz...76.8MHz
	- TX 15KHz...76.8MHz
	- configuration via "tiny I2C" (just accepting 10 byte configuration data, no read)
	- data in/out via SAI
	- sample rates 48/96/192 ksps

##### to do:
	- extended I2C configuration using registers and read/write :construction:
	- implementation of second ADC
	- implementation of AD936x
	- implementation of RAM
	- implementation of USB interface
	- implementation of run time reconfiguration of FPGA

:construction: = we are working on this at the moment

**More content will be added dynamically.**

# Folder Structure

- `boards/<BoardName_Config`: A Folder of project for board "BoardgName" with an optional suffix to indicate some subvariant of the configuration.  Inside this folder subfolders for build and also some quartus folders live. Only board specific files should be stored here.
	- The project bitstream binary should have the same name as the project folder (makes it easier to identify which is which if you combine different bitstreams)
- `modules` : All HDL modules / IP configurations which are shared or are intended for sharing between different boards.
	- Use a naming strategy for IP configurations which creates speaking names and permits similar modules to use the same naming scheme (`i2c_pll_rom_76m8.v` `i2c_pll_rom_153m6.v` ).  Use only lowercase letters in filenames.
	- Naming the module inside the Verilog file identical to the filename will make Quartus automatically find the module by name, so this is recommended.
	- Subfolders are fine, but use these wisely.
- 'old' A temporary home for our old gateware, until everthing has been harvested from it. Do not use for development.
