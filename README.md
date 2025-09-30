## O-GEST Algorithm
O-GEST is an automatic overground gait events detector for marker-based and markerless analysis. It employs B-Spline-based geometric models that imitate the horizontal trajectory of foot landmarks (to smooth them in a pattern-aware manner) and leverages gait-dependent thresholds along with optimal coefficients to detect events (foot-strikes and foot-offs) and also to compute spatiotemporal parameters on healthy and pathological gait. O-GEST detects gait events with an overall accuracy of 13.5 ms for foot-strike and 12.6 ms for foot-off on variety of pathologies (Healthy Adults, HOA, Stroke, Parkinson, and also CP-TD Children).

## Reference: 

M. Hatamzadeh, L. Busé, K. Turcot, R. Zory, 2025, **"O-GEST: Overground gait events detector using b-spline-based geometric models for marker-based and markerless analysis"** J. Biomechanics, 189, 112803, https://doi.org/10.1016/j.jbiomech.2025.112803.

M. Hatamzadeh, L. Busé, F. Chorin, P. Alliez, J.D. Favreau, R. Zory, 2022, **"A kinematic-geometric model based on ankles’ depth trajectory in frontal plane for gait analysis using a single RGB-D camera"**, J. Biomechanics, 145, 111358, https://doi.org/10.1016/j.jbiomech.2022.111358.

## Requirements
This algorithm requires the below-mentioned toolboxes to be installed:
* **Signal Processing Toolbox**
* **Optimization Toolbox**

To find and install them, navigate to the *Matlab Home* --> *Add Ons* --> *Get Add-Ons* and search for the toolboxes. The current algorithm is developed in Matlab R2022b, but could work in earlier versions as well.

## How to use:  
The main function that should be used is O-GEST, which can be executed as follows:
```sh
Setting.Visualization = "ON" ;  
[ Events, SpatioTemporals , Info ] = O_GEST ( Time , JointsDepth_L , JointsDepth_R , Setting );
```
**Note:** You need to change the Matlab directory to where the O-GEST functions are, or add the folder of O-GEST functions to the Matlab search path. 

## Inputs:
**[ Time ]:** Is a vertical vector with a size of N×1 

**[ JointsDepth_L ]** and **[ JointsDepth_R ]:** are N×M matrices containing horizontal trajectory of the left and the right foot landmarks. their size is N×1 in single landmark configuration, N×2 in dual landmarks configuration, or N×3 in triple landmarks configuration (see the example section for clarification).  

**[ Setting ]:** Visualization of the output (ON / OFF).     
              
## Outputs:
**[ Events ]:** Contains the time and location of the detected events for each leg.

**[ SpatioTemporal ]:** Contains the calculated parameters for each foot (gait speed, step length, step time, stride length, stride time, swing and stance phase percentages, etc).

**[ Info ]:** Contains the fitting information for each landmark such as the number of control points, sections data, etc.

## Example
One example is included which could be used for familiarization on how to use the algorithm. The folder of "Example" contains a C3D file named Example_Gait.C3D and its data in .MAT format (only the required data) read by [Biomechanical-ToolKit (BTK)](https://github.com/moveck-community/moveck_bridge_btk). The Matlab file contains only the foot markers' horizontal trajectory, time vector, and the detected events on the C3D file. To use O-GEST on the example data, three different configurations could be used. We suggest you use the best configurations, either triple landmarks [Toe, Ankle, Heel] or a combination of [Toe, Heel]. The other configurations are only made available for utilization in the absence of some landmarks, and can result in slightly higher errors than the best configurations.
```sh
cd("change directory to where the example folder is ... ") 
load Example_Gait.mat
``` 
**Configuration 1:** To run the O-GEST in its best configuration (triple landmark), use:
```sh
JointsDepth_L = [ Toe_L_Horizontal , Ankle_L_Horizontal , Heel_L_Horizontal ];
JointsDepth_R = [ Toe_R_Horizontal , Ankle_R_Horizontal , Heel_R_Horizontal ];
```

![tot](https://github.com/Mehran-Hatamzadeh/O-GEST/blob/main/Images/TripleLandmarks.jpg)

**Configuration 2:** For dual landmark configuration, the code below could be used:
```sh
JointsDepth_L = [ Toe_L_Horizontal , Heel_L_Horizontal ];
JointsDepth_R = [ Toe_R_Horizontal , Heel_R_Horizontal ];
```
(or a dual combination of any of them with the Ankles)

![tot](https://github.com/Mehran-Hatamzadeh/O-GEST/blob/main/Images/DualLandmarks.jpg)

**Configuration 3:** For single landmark configuration, the code below could be used: 
```sh
JointsDepth_L = [ Ankle_L_Horizontal ];
JointsDepth_R = [ Ankle_R_Horizontal ];
```
(or only Toes or Heels instead of the Ankles)

![tot](https://github.com/Mehran-Hatamzadeh/O-GEST/blob/main/Images/SingleLandmarks.jpg)

afterward, you can use the O-GEST to run on the example, as mentioned in the "How to run" Section.

## Run on C3D
To run O-GEST on C3D files, foot markers' horizontal trajectory should be read by Biomechanical-ToolKit (BTK). Then, by feeding them into the O-GEST algorithm according to the above-mentioned instruction, gait events can be detected and can be overwritten on the same C3D file using the functions that BTK provides. [Download BTK](https://github.com/moveck-community/moveck_bridge_btk/releases)
 
## License

GNU Affero General Public License (GNU AGPL V3.0)

Copyright (C) 2024 Mehran Hatamzadeh

This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>
