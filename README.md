## O-GEST Algorithm
O-GEST is an Overground gait events detector for marker-based and markerless analysis. It employs B-Spline-based geometric models that imitate the horizontal trajectory of foot landmarks (to smooth them in a pattern-aware manner) and leverages gait-dependent thresholds along with optimal coefficients to detect gait events (foot-strikes, foot-offs), and to compute spatiotemporal parameters in healthy and pathological gait.

## Contributors: 
Mehran Hatamzadeh, Laurent Buse, Katia Turcot, Raphael Zory 

## Requirements
If you have installed Matlab with all its toolboxes, no other tool is required. However, if you don't have all the toolboxes installed or you are using the free trial, the below-mentioned toolboxes should be installed from the Add-On section of Matlab manually:
* Signal Processing Toolbox
* Optimization Toolbox

To install them, navigate to the Matlab Home ---> Add Ons ---> Get Add-Ons and search for the above-mentioned toolboxes to install. The current algorithm is developed in Matlab R2022b, but could work in earlier versions as well.

## How to use:  

The main function that should be used is O-GEST.mat, which can be executed as follows:
```sh
Setting.Visualization = "ON" ;  
[ Events, SpatioTemporals , Info ] = O_GEST ( Time , JointsDepth_L , JointsDepth_R , Setting );
```
Note: you need to change the directory of Matlab to where the O-GEST functions are, or you can add the folder of O-GEST functions to the Matlab search path. 

## Inputs:

[ Time ]: Is a vertical vector with a size of N×1 

[ JointsDepth_L ]: Is N×M matrix containing horizontal trajectory of left foot landmarks. Its size is N×1 in single landmark configuration, N×2 in dual landmarks configuration, or N×3 in triple landmarks configuration (see the example section below).  

[ JointsDepth_R ]: Is N×M matrix containing horizontal trajectory of right foot landmarks. Its size is N×1 in single landmark configuration, N×2 in dual landmarks configuration, or N×3 in triple landmarks configuration(see the example section below). 

[ Setting ]: Visualization of the output (ON / OFF).     
              
## Outputs:

[ Events ]: Contains the time and location of the detected events for each leg.

[ SpatioTemporal ]: Contains the calculated parameters after implementation of the algorithm for each foot (gait speed, step length, step time, stride length, stride time, swing and stance phase percentages, etc).

[ Info ]: Contains the fitting information for each landmark such as the number of control points, sections data, etc.

## Example
One example is included which could be used for familiarization on how to use the algorithm. the folder of "Example" contains a C3D file named Example_Gait.C3D and its data in .MAT format (only the required data) which is read by BTK. The Matlab file (Example_Gait.MAT) contains only the foot markers' horizontal trajectory, time vector, and the detected events on the C3D file. To use O-GEST for events detection and comparison with the events that fall on the force plates (there are some events before and after reaching the force plates), three different configurations could be used:

```sh
cd("change directory to where the example folder is ... ") 
load Example_Gait.mat
``` 
After loading the data, to run the O-GEST in its best configuration, the code below could be used:
```sh
JointsDepth_L = [ Ankle_L_Horizontal , Toe_L_Horizontal , Heel_L_Horizontal ];
JointsDepth_R = [ Ankle_R_Horizontal , Toe_R_Horizontal , Heel_R_Horizontal ];
```
![tot](https://github.com/Mehran-Hatamzadeh/O-GEST/blob/main/Images/TripleLandmarks.png)

For dual landmark configuration, the code below could be used:
```sh
JointsDepth_L = [ Toe_L_Horizontal , Heel_L_Horizontal ];
JointsDepth_R = [ Toe_R_Horizontal , Heel_R_Horizontal ];
```
(or dual combination of any of them with the Ankles)
![tot](https://github.com/Mehran-Hatamzadeh/O-GEST/blob/main/Images/DualLandmarks.png)


For single configuration, the code below could be used: 
```sh
JointsDepth_L = [ Ankle_L_Horizontal ];
JointsDepth_R = [ Ankle_R_Horizontal ];
```
(or only Toes or Heels instead of the Ankles)
![tot](https://github.com/Mehran-Hatamzadeh/O-GEST/blob/main/Images/SingleLandmarks.png)

afterwards, you can use the O-GEST to run on the example, as mentioned in "How to run" Section.

## Run on C3D
To run O-GEST on C3D files, the above-mentioned procedure, including reading C3D using BTK (Biomechanical Toolkit), extracting foot markers horizontal trajectory and feeding them into O-GEST should be done in Matlab.

## License

GNU Affero General Public License (GNU AGPL V3.0)

Copyright (C) 2024 Mehran Hatamzadeh

This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>
