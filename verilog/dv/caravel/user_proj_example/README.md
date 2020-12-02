# Mega-Project Counter Tests

The directory includes three tests for the counter mega-project example: 

1) IO Ports Test: 

	* Configures the user space lower 8 IO pins as outputs
	* Observes the counter value through the configured pins in the testbench

 2) Logic Analyzer Test 1:
 
	* Configures LA probes [31:0] as inputs to the management SoC to monitor the counter value 
	* Configures LA probes [63:32] as outputs from the management SoC to set the counter initial value 
	* Flags when counter value exceeds 500 through the management SoC gpio
	* Outputs message to the UART when the test concludes successfuly
  
 3) Logic Analyzer Test 2:
 
	* Configures LA probes [64] and [65] as outputs from the management SoC to set counter clock and reset values
	* Provides counter clock and monitors the counter value after five clock cycles
