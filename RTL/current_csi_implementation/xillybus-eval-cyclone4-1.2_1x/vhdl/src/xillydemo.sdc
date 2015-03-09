# Clock constraints

create_clock -name "clk_125" -period 8.000ns [get_ports {clk_125}]
create_clock -name "clk_50" -period 20.000ns [get_ports {clk_50}]
create_clock -name "pcie_refclk" -period 10.000ns [get_ports {pcie_refclk}]

# Automatically constrain PLL and other generated clocks
derive_pll_clocks -create_base_clocks

# Automatically calculate clock uncertainty to jitter and other effects.
derive_clock_uncertainty
