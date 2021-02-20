# OVI40 DDC/DUC RF Board using Cyclone10LP FPGA

More content will be added. 

# Folder Structure

- `boards/<BoardName_Config`: A Folder of project for board "BoardgName" with an optional suffix to indicate some subvariant of the configuration.  Inside this folder subfolders for build and also some quartus folders live. Only board specific files should be stored here.
	- The project bitstream binary should have the same name as the project folder (makes it easier to identify which is which if you combine different bitstreams)
- `modules` : All HDL modules / IP configurations which are shared or are intended for sharing between different boards. 
	- Use a naming strategy for IP configurations which creates speaking names and permits similar modules to use the same naming scheme (`I2C_PLL_ROM_76M8.v` `I2C_PLL_ROM_153M6.v` ). 
	- Naming the module inside the Verilog file identical to the filename will make Quartus automatically find the module by name, so this is recommended.
	- Subfolders are fine, but use these wisely. 
