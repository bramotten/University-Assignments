Circuits assignment for datastructures and algorithms,
by Bram Otten, UvA ID 10992456, 30-03-2018.
------------------------------------------------------
Tested on 64-bit Python 3.6.5.
External libraries required:
- Numpy (only for a printable grid)
  # python[3] -m pip install numpy
-----------------------------------
The two .csv files were obtained by converting the
provided .xlsx's with Excel using default settings.
---------------------------------------------------
The wire.py file runs without arguments and contains everything but
that csv input. Run with (bracketed stuff optional):
# python[3] ./*.py
-------------------------------------------------------------------
If debug prints are wanted, the -d argument can be passed along.
This version may also skip boards or netlists, a selection can
be made in the .py file (the *_todo arrays).
# python[3] ./wire.py -d
------------------------------------------------------------------
Approximate runtimes in debug mode (on an i7-6700HQ, Windows 10, this
piece of art is completly single-core and also works (slower) on Linux):
- Board 1, netlist 1: 20 seconds.
- Board 1, netlist 2: 25 seconds.
- Board 1, netlist 3: 2 minutes.
- Board 2, netlist 1: 1 minute.
- Board 2, netlist 2: 5 minutes.
- Board 2, netlist 3: > 60 minutes (gets to 65/70 at least).
------------------------------------------------------------------------
A sample output is  provided in the ./Solutions/.txt's, but please do run the
.py because I didn't just run a shuffle overnight or hard-code or whatever.
-----------------------------------------------------------------------------
About the design choice: I mainly use heuristics to keep locations that will
probably become busy in the future free, and try to make the easiest and
hardest connections first.
