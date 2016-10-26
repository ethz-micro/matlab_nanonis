# ==================================================
#  SXM viewer
# ==================================================

The SXM viewer allows to open sxm files and have a fast overview of all channels stored within a SXM image.

# --------------------------------------------------
#  Setup
# --------------------------------------------------

In order to use the DAT viewer you need to set local paths for the NanoLib and the path to directory where images are saved.
The first time you run the viewer you will be asked to find paths. Information will be saved in a file ‘localSettings.tct’ in the same directory  where ‘SXM.m’ is (this directory) with the following informations:

% local path to NanoLib. variable ‘nanoPath’ MUST be a cell.
nanoLib	/Users/grandegiove/Documents/MATLAB/matlab_nanonis/NanoLib
% your path to sxm data
dataPath	/Volumes/micro/CLAM2/hpt_c6.2/Nanonis/Data

# --------------------------------------------------
#  Usage
# --------------------------------------------------

1. Run SXM viewer main file:
   >> SXM

2. Select the process type in the popupmenu (default = Raw)

3. Press open button and search for the directory where measurements are;

3. Press items in the list box in order to let them appear in a new figure;

4. Press on plotted channels to export them on a new figure.