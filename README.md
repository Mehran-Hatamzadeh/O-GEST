## O-GEST
O-GEST is an Overground gait events detector for marker-based and markerless analysis. It employs B-Spline-based geometric models that imitate the horizontal trajectory of foot landmarks (to smooth them in a pattern-aware manner) and leverages gait-dependent thresholds along with optimal coefficients to detect gait events (foot-strikes, foot-offs), and to compute spatio-temporal parameters in healthy and pathological gait.

## Reference: 
Mehran Hatamzadeh, Laurent Buse, Katia Turcot, Raphael Zory, Overground gait events detector using B-Spline-based geometric models for marker-based and markerless analysis, Journal of "-------" 

## How to use:  

The main function that should be used is O-GEST.mat, which can be executed as follows:
```sh
Setting.Optimizer = "QP" ;
Setting.Visualization = "ON" ;  
[ Events, SpatioTemporals , Info ] = O_GEST ( Time , JointsDepth_L , JointsDepth_R , Setting );
```
Note: you need to change the directory of Matlab to where the O-GEST functions are, or you can add all the O-GEST functions into Matlab search path.
## Inputs:

[ Time ]: Is a vertical vector with size of N by 1 

[ JointsDepth_L ]: Is N by M matrix containing horizontal trajectory of left foot landmarks. Its size is N by 1 in single landmark configuration, N by 2 in dual landmarks configuration, or N by 3 in triple landmarks configuration (see the example section below).
                
[ JointsDepth_R ]: Is N by M matrix containing horizontal trajectory of right foot landmarks. Its size is N by 1 in single landmark configuration, N by 2 in dual landmarks configuration, or N by 3 in triple landmarks configuration(see the example section below).               
                
[ Setting ]: It has two options, one for visualization (ON) which could be turned (OFF) as well, and the other to select the optimizer (QP or SQP). It is recommended to use QP optimizer which is faster than the SQP.      
                 
## Outputs:

[ Events ]: Contains the time, and location of the detected events for each leg.

[ SpatioTemporal ]: Contains the calculated parameters after implementation of the algorithm for each foot, including: gait speed, step length, step time, stride length, stride time, cadence, swing and stance phase percentages during walking.

[ Info ]: Contains the information of fitting for each landmark such as number of control points, sections data and etc.

## Example
One example is included which could be used for familiarization on how to use the algorithm. the folder of "Example" contains a C3D file named Example_Gait.C3D and its data in .MAT format (only the required data) which are read by BTK. The matlab file (Example_Gait.MAT) contains only the foot markers horizontal trajectory, time vector, and all events that are deceted on the C3D file. To use O-GEST for events detection and comparison with the events that fall on the force plates (there are some events before and after reaching the force plates), three different configurations could be use:

```sh
cd("change directory to where the example folder is ... ") 
load Example.mat
``` 
After loading the data, to run the O-GEST in triple landmark configuration which is the most powerfull configuration, the code below could be used:
```sh
JointsDepth_L = [ Ankle_L_Horizontal , Toe_L_Horizontal , Heel_L_Horizontal ];
JointsDepth_R = [ Ankle_R_Horizontal , Toe_R_Horizontal , Heel_R_Horizontal ];
```
For dual landmark configuration, the code below could be used:
```sh
JointsDepth_L = [ Toe_L_Horizontal , Heel_L_Horizontal ];
JointsDepth_R = [ Toe_R_Horizontal , Heel_R_Horizontal ];
```
(or dual combination any of them with Ankles)

For single configuration, the code below could be used: 
```sh
JointsDepth_L = [ Ankle_L_Horizontal ];
JointsDepth_R = [ Ankle_R_Horizontal ];
```
(or only Toes or Heels instead of Ankles)
afterwards, you can use the O-GEST to run on the example, as mentioned in "How to run" Section.

## Run on C3D
To run O-GEST on C3D files, the above mentioned procedure, including reading C3D using BTK (Biomechanical ToolKit), extracting foot markers horizontal trajectory and feeding them into O-GEST should be done in Matlab.
