# Optimus-Cura-CNC-plugin
Plugin for Cura to connect wirelessly from your computer, to the Optimus and set it up for CNC jobs.

# optimus.cps
Optimus post processor configuration for Fusion 360. This version is based on the version from febtop released on 20170913 (and not the newer one from 20171023). It adds an option called "resetOriginBeforeStart". Set this option to "true" to add an origin reset at start of your gcode program file.

To use this option process as follows:
1. Do not use the tool length sensor (probe).
2. In your Fusion 360 CAM setup set the origin to the lower left corner on the top surface of your stock material.
3. Before starting your program, move your cutting tool to the origin on the stock material as defined in Fusion 360. The tip of the tool should just touch the surface.
4. Start the program and milling should work fine.
