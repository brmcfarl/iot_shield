Please refer to the documentation on http://xillybus.com. This text is just
a starter.

Software environment
====================

This evaluation bundle can be implemented without any purchase of software or
core. More specifically, the demo bundle can be implemented with the current
Web Edition of Quartus II, which is available for download from Altera's
site at no cost. 

The Xillybus core depends on Altera's IP Compiler for PCI Express, which is
available along with Quartus II, and does not require a special license key.

The core was developed with Quartus II 12.0, but later versions apply as well.

Quick start:
===========

(1) Open Quartus II by double-clicking xillydemo.qpf in either the 'verilog'
    or 'vhdl' directory, depending on your preference.

(2) Before compiling the design, create a local copy of the IP compiler for
    PCI Express core: Launch the MegaWizard Plug-In Manager from within
    Quartus II from the Tools menu. Choose Edit an existing custom megafunction
    variation, and pick the pcie_c4_1x.v file in the pcie_core directory.
    When the wizard for IP Compiler for PCI Express opens, just click Finish
    to generate the core's files, and click Exit when the process finishes.
    If a dialog box asking whether the Quartus II IP file should be added to
    the project, both "Yes" and "No" are fine, but picking "No" will reduce
    the number of warnings during compilation.

(3) Compile the design by double-clicking "Compile Design" on the Task bar
    to the left on Quartus II. The compilation will produce several warnings,
    but no Critical Warnings nor errors.

(4) The programming file to use is xillydemo.sof.

File outline
============

The bundle consists of four directories:

* pcie_core -- The initial source file for creating the IP Compiler for PCI
  Express core, using Altera's MegaWizard application.
* core -- The binary of the Xillybus core is stored here
* instantiation templates -- Contains the instantiation template for the core
  in Verilog and VHDL
* verilog -- Contains the project file for the demo and the sources in Verilog
  (in the 'src' subdirectory)
* vhdl -- Contains the project file for the demo and the sources in VHDL (in
  the 'src' subdirectory)

Note that the verilog and vhdl directories also contain the QSF file with pin
assignment for the Cyclone IV GX Transceiver starter board. This file must be
edited if another board is targeted.

Also note that the vhdl directory contains Verilog files, but none of which
should need editing by user.

The interface with Xillybus takes place in the xillydemo.v or xillydemo.vhd
files in the respective 'src' subdirectories. This is the file to edit in
order to try Xillybus with your own data sources and sinks.

--------------------------------------------------

For further information about how to get started, run tests and hack the
code, please refer to the documentation in the site: http://xillybus.com
