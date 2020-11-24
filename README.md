# singleaniso-dataplot
A collection of MATLAB functions that parse and plot magnetic data from OpenMolcas version 18.09
 
## Setup
The folder containing these scripts should be added to your MATLAB path. This can be done by clicking the **Set Path** button under the **Home** tab. See [this](https://www.mathworks.com/help/matlab/matlab_env/add-remove-or-reorder-folders-on-the-search-path.html) for more details.

## Usage
Datafiles (.dat) originating from MOLCAS v8.2 containing (1) state information, (2) matrix elements, and (3) wavefuntion contributions are parsed by `parse_singleaniso` and plotted by `plot_singleaniso` whose arguments are filenames. 

