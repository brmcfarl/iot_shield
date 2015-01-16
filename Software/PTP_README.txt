To enable PTP timestamping in the Galileo kernel, apply to patch
(chall_ptp.patch) to the kernel source and recompile.

The following kernel options should be enabled statically:
    -PHY timestamping
    -PTP clock
    -PPS
    -STMMAC PTP (1588-2005) [leave default clock speed]