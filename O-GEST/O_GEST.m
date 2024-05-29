function [Events,SpatioTemporals,Info] = O_GEST(Time,JointsDepth_L,JointsDepth_R,Setting)
% ========================================================================
% Developer:Mehran Hatamzadeh
%           Universite Cote d'Azur, LAMHESS, INRIA
% -------------------------------------------------------------------------
% Reference:"-------" 
%           M. Hatamzadeh, L. Buse, K. Turcot, R. Zory
%           Journal of "-------"
% -------------------------------------------------------------------------
% Description:  
% This is the main function of the O-GEST algorithm to fit the models on
% horizontal trajectory of foot landmarks,to extract gait events, and to
% calculate spatio-temporal parameters
% -------------------------------------------------------------------------               
%  Inputs:
%  [Time]: Is a Vertical vector with size of N*1     
%  [JointsDepth_L]:Is N*M matrix containing horizontal trajectory of left foot landmarks.
%                Its size is N*1 in single landmark configuration, N*2 in dual landmarks
%                configuration, or N*3 in triple landmarks configuration(see the examples).
%  [JointsDepth_R]:Is N*M matrix containing horizontal trajectory of right foot landmarks.
%                Its size is N*1 in single landmark configuration, N*2 in dual landmarks
%                configuration, or N*3 in triple landmarks configuration(see the examples).                
%  [Setting]:It has two options, one for visualization (ON) which could be turned (OFF) as well.              
%            Setting.Visualization="ON" or "OFF";
%            The other to select optimizer: Setting.Optimizer="QP" or "SQP";
%            It is recommended to use QP optimizer which is faster than the SQP.
%-------------------------------------------------------------------------                  
%  Outputs:
% The outputs of the algorithm are [Events], which contains time, sample number, and
% location of events for each foot, [SpatioTemporal] parameters calculated after 
% the implementation of the algorithm for each foot, and [Info] which contains
% the information of fitting for each landmarks such as number of control
% points, used model, sections data and etc.
% ========================================================================
% License: GNU Affero General Public License (GNU AGPL V3.0)
% ========================================================================
%     Copyright (C) 2024  Mehran Hatamzadeh
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU Affero General Public License as
%     published by the Free Software Foundation, either version 3 of the
%     License, or (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU Affero General Public License for more details.     
%     
%     You should have received a copy of the GNU Affero General Public License
%     along with this program.  If not, see <https://www.gnu.org/licenses/>
% ========================================================================

Optimizer=Setting.Optimizer;
Visualization=Setting.Visualization;

INFO_L1=[];INFO_L2=[];INFO_L3=[];INFO_R1=[];INFO_R2=[];INFO_R3=[];


if max(JointsDepth_L(:,1))-min(JointsDepth_L(:,1))>20 
    JointsDepth_L=JointsDepth_L./1000;
    JointsDepth_R=JointsDepth_R./1000;    
end

Setting=Trend_Finder(Time,JointsDepth_L,JointsDepth_R,Setting);

if Setting.Type=="Without_Intersection" && Setting.Lower=="Left"
   JointsDepth_L=JointsDepth_L+Setting.Shift_Offset;
elseif Setting.Type=="Without_Intersection" && Setting.Lower=="Right"
    JointsDepth_R=JointsDepth_R+Setting.Shift_Offset;
end


if Setting.Direction=="Upward"
   JointsDepth_L=-JointsDepth_L;
   JointsDepth_R=-JointsDepth_R;
end


if width(JointsDepth_L)==1
    try
        Model="OneLandmark";
        cprintf('*blue',   'Gait GEST Started In Single Landmark Pair Configuration\n');
        [INFO_L1,INFO_R1] = GEST_OneLandmark (Time,JointsDepth_L,JointsDepth_R,Optimizer,Setting);
        cprintf('*blue',   'Gait GEST Executed Successfully\n');
        [Events_Location,Events_Time] = Events_Finder (INFO_L1,INFO_R1,INFO_L2,INFO_R2,INFO_L3,INFO_R3,Setting); 
        [INFO_L1]=Trend_INFO_Corrector(INFO_L1,Setting);
        [INFO_R1]=Trend_INFO_Corrector(INFO_R1,Setting);
        if Setting.Type=="Without_Intersection" && Setting.Lower=="Left"
            [INFO_L1]=Type_INFO_Corrector(INFO_L1,Setting);
        elseif Setting.Type=="Without_Intersection" && Setting.Lower=="Right"
            [INFO_R1]=Type_INFO_Corrector(INFO_R1,Setting);
        end
        if Visualization=="ON"
            try
               figure(123);
               [INFO_L1,INFO_R1] = SS_DS_Areas (INFO_L1,INFO_R1,Events_Time,Setting);
               hold on;
               [INFO_L1,INFO_R1] = Visualization_GEST (INFO_L1,INFO_R1); 
            catch
                cprintf('*red',   'Visualization Failed!!\n');
            end
        end
    catch
        cprintf('*red',   'Execution Of Gait GEST Failed!!\n');
    end
elseif width(JointsDepth_L)==2
    try
        cprintf('*blue',   'Gait GEST Started In Dual Landmark Pairs Configuration\n');
        Model="TwoLandmarks";
        cprintf('*blue',   'Optimizing First Landmark Pair\n');
        [INFO_L1,INFO_R1] = GEST_OneLandmark (Time,JointsDepth_L(:,1),JointsDepth_R(:,1),Optimizer,Setting);
        cprintf('*blue',   'Optimizing Second Landmark Pair\n');
        [INFO_L2,INFO_R2] = GEST_OneLandmark (Time,JointsDepth_L(:,2),JointsDepth_R(:,2),Optimizer,Setting);

        cprintf('*blue',   'Gait GEST Executed Successfully\n');
        [Events_Location,Events_Time] = Events_Finder (INFO_L1,INFO_R1,INFO_L2,INFO_R2,INFO_L3,INFO_R3,Setting); 
        [INFO_L1]=Trend_INFO_Corrector(INFO_L1,Setting);
        [INFO_R1]=Trend_INFO_Corrector(INFO_R1,Setting);
        [INFO_L2]=Trend_INFO_Corrector(INFO_L2,Setting);
        [INFO_R2]=Trend_INFO_Corrector(INFO_R2,Setting);
        if Setting.Type=="Without_Intersection" && Setting.Lower=="Left"
            [INFO_L1]=Type_INFO_Corrector(INFO_L1,Setting);
            [INFO_L2]=Type_INFO_Corrector(INFO_L2,Setting);
        elseif Setting.Type=="Without_Intersection" && Setting.Lower=="Right"
            [INFO_R1]=Type_INFO_Corrector(INFO_R1,Setting);
            [INFO_R2]=Type_INFO_Corrector(INFO_R2,Setting);
        end
        if Visualization=="ON"
            try
                figure(123);
                [INFO_L1,INFO_R1] = SS_DS_Areas (INFO_L1,INFO_R1,Events_Time,Setting);
                hold on;
                [INFO_L1,INFO_R1] = Visualization_GEST (INFO_L1,INFO_R1); 
                hold on;
                [INFO_L2,INFO_R2] = Visualization_GEST (INFO_L2,INFO_R2); 
            catch
                cprintf('*red',   'Visualization Failed!!\n');
            end  
        end
    catch
        cprintf('*red',   'Execution Of Gait GEST Failed!!\n');
    end
elseif width(JointsDepth_L)==3
    try
       cprintf('*blue',   'Gait GEST Started In Triple Landmark Pairs Configuration\n');
       Model="ThreeLandmarks";
        cprintf('*blue',   'Optimizing First Landmark Pair\n');
        [INFO_L1,INFO_R1] = GEST_OneLandmark (Time,JointsDepth_L(:,1),JointsDepth_R(:,1),Optimizer,Setting);
        cprintf('*blue',   'Optimizing Second Landmark Pair\n');
        [INFO_L2,INFO_R2] = GEST_OneLandmark (Time,JointsDepth_L(:,2),JointsDepth_R(:,2),Optimizer,Setting);
        cprintf('*blue',   'Optimizing Third Landmark Pair\n');
        [INFO_L3,INFO_R3] = GEST_OneLandmark (Time,JointsDepth_L(:,3),JointsDepth_R(:,3),Optimizer,Setting);

       cprintf('*blue',   'Gait GEST Executed Successfully\n');
       [Events_Location,Events_Time] = Events_Finder (INFO_L1,INFO_R1,INFO_L2,INFO_R2,INFO_L3,INFO_R3,Setting); 
        [INFO_L1]=Trend_INFO_Corrector(INFO_L1,Setting);
        [INFO_R1]=Trend_INFO_Corrector(INFO_R1,Setting);
        [INFO_L2]=Trend_INFO_Corrector(INFO_L2,Setting);
        [INFO_R2]=Trend_INFO_Corrector(INFO_R2,Setting);
        [INFO_L3]=Trend_INFO_Corrector(INFO_L3,Setting);
        [INFO_R3]=Trend_INFO_Corrector(INFO_R3,Setting);
        if Setting.Type=="Without_Intersection" && Setting.Lower=="Left"
            [INFO_L1]=Type_INFO_Corrector(INFO_L1,Setting);
            [INFO_L2]=Type_INFO_Corrector(INFO_L2,Setting);
            [INFO_L3]=Type_INFO_Corrector(INFO_L3,Setting);
        elseif Setting.Type=="Without_Intersection" && Setting.Lower=="Right"
            [INFO_R1]=Type_INFO_Corrector(INFO_R1,Setting);
            [INFO_R2]=Type_INFO_Corrector(INFO_R2,Setting);
            [INFO_R3]=Type_INFO_Corrector(INFO_R3,Setting);
        end
       if Visualization=="ON"
            try
                figure(123);
                [INFO_L1,INFO_R1] = SS_DS_Areas (INFO_L1,INFO_R1,Events_Time,Setting);
                hold on;
                [INFO_L1,INFO_R1] = Visualization_GEST (INFO_L1,INFO_R1); 
                hold on;
                [INFO_L2,INFO_R2] = Visualization_GEST (INFO_L2,INFO_R2); 
                hold on;
                [INFO_L3,INFO_R3] = Visualization_GEST (INFO_L3,INFO_R3);
            catch
                cprintf('*red',   'Visualization Failed!!\n');
            end  
       end
    catch
        cprintf('*red',   'Execution Of Gait GEST Failed!!\n');
    end
end


Events.Time=Events_Time;
Events.Location=Events_Location;

[SpatioTemporals] = Spatio_Temporal_Calculator (Events);

if Model=="OneLandmark"
    Info.Left_1=INFO_L1;
    Info.Right_1=INFO_R1;
elseif Model=="TwoLandmarks"
    Info.Left_1=INFO_L1;
    Info.Left_2=INFO_L2;
    Info.Right_1=INFO_R1;
    Info.Right_2=INFO_R2;
elseif Model=="ThreeLandmarks"
    Info.Left_1=INFO_L1;
    Info.Left_2=INFO_L2;
    Info.Left_3=INFO_L3;
    Info.Right_1=INFO_R1;
    Info.Right_2=INFO_R2;
    Info.Right_3=INFO_R3;
end

end