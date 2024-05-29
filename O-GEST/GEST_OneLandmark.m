function [INFO_L1,INFO_R1] = GEST_OneLandmark (Time,JointsDepth_L,JointsDepth_R,Optimizer,Setting)
% ========================================================================
% Description: This function performs models fitting on one pair of 
%              landmark according to the user-defined optimizer.
% ========================================================================
% Developer:Mehran Hatamzadeh
%           Universite Cote d'Azur, LAMHESS, INRIA
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
[JointsDepth_L,JointsDepth_R,Time]=Data_Checker(JointsDepth_L,JointsDepth_R,Time);

[INFO_L1,INFO_R1] = Info_Detetctor (JointsDepth_L,JointsDepth_R,Time);
 
[Setting.NCP_L1,Setting.Intensity_L1]=NCP_Finder(INFO_L1);
[Setting.NCP_R1,Setting.Intensity_R1]=NCP_Finder(INFO_R1);

INFO_L1.Intensity=Setting.Intensity_L1;
INFO_R1.Intensity=Setting.Intensity_R1;

INFO_L1.Ncp=Setting.NCP_L1;
INFO_R1.Ncp=Setting.NCP_R1;
%--------------------------
INFO_L1.Basis = Cubic_Bspline_Basis_Function (INFO_L1.Ncp);
INFO_R1.Basis = Cubic_Bspline_Basis_Function (INFO_R1.Ncp);
INFO_L1.Knots = [ zeros(1,4) , 1:1:INFO_L1.Ncp-4 , zeros(1,4)+(INFO_L1.Ncp-3)];
INFO_R1.Knots = [ zeros(1,4) , 1:1:INFO_R1.Ncp-4 , zeros(1,4)+(INFO_R1.Ncp-3)];
%--------------------------
[INFO_L1] = Initial_Control_Points(INFO_L1);
[INFO_R1] = Initial_Control_Points(INFO_R1);
%--------------------------
[INFO_L1.IDs,INFO_R1.IDs]=ID_Cycles_Up_Down_Events_Indexes(INFO_L1,INFO_R1);
[A_Eq,b_Eq,A_InEq,b_InEq,Lb,Ub,x0,INFO_L1,INFO_R1]= Constraints_Creator(INFO_L1,INFO_R1);
INFO_Optimization.Optimization_Weights=[1,1];   
[Normalization_E]=Normalization_Error_calculator_OneLandmark (x0,INFO_L1,INFO_R1);

Total_Cycles=INFO_L1.N_Cycle + INFO_R1.N_Cycle;

if Total_Cycles<=5
    MaxIteration=500;
elseif Total_Cycles<=10
    MaxIteration=750;
elseif Total_Cycles<=15
    MaxIteration=1000; 
elseif Total_Cycles>15
    MaxIteration=1250;
end

%-----------------
[INFO_L1,INFO_R1]=Intersections_Finder(INFO_L1,INFO_R1);
%==================Optimization====================

if Optimizer=="SQP"
   cprintf('blue',   'Sequential Quadratic Programming (SQP) Is Running ...\n');
   options = optimoptions('fmincon','PlotFcns',@optimplotfval,'Algorithm','sqp','StepTolerance',1e-6,'MaxFunctionEvaluations',7000,'MaxIterations',70);
   x = fmincon(@(x) Error_calculator_OneLandmark (x,INFO_L1,INFO_R1,INFO_Optimization,Normalization_E) ,x0,A_InEq,b_InEq,A_Eq,b_Eq,Lb,Ub,[],options);
   Dim=2;
   x_L=x(1:INFO_L1.N_Param,1);
   x_R=x(INFO_L1.N_Param+1:end,1);
   [INFO_L1.CPs] = Solution_Completion_and_CPs_Update (x_L,Dim,INFO_L1);
   [INFO_R1.CPs] = Solution_Completion_and_CPs_Update (x_R,Dim,INFO_R1);
   %-----------------
   [INFO_L1,INFO_R1]=Intersections_Finder(INFO_L1,INFO_R1);
   %-----------------
   [INFO_L1,INFO_R1]=Extremities_Finder_Varying(INFO_L1,INFO_R1);
   %-----------------
   cprintf('blue',   'SQP Optimization Is Finnished\n'); 
elseif Optimizer=="QP"
       INFO_Optimization.MaxIteration=MaxIteration; 
       INFO_Optimization.Epsilon=2e-4;
       INFO_Optimization.Damping_Weight=0.5;
       Iter=1;
       WL=INFO_Optimization.Optimization_Weights(1,1);
       WR=INFO_Optimization.Optimization_Weights(1,2);
       NORM=zeros(1,INFO_Optimization.MaxIteration);
       ERROR=zeros(1,INFO_Optimization.MaxIteration);
       X_All=zeros(INFO_Optimization.MaxIteration,height(x0));
       Step_Norm=1;
       cprintf('blue',   'Quadratic Programming (QP) Is Running ...\n');
       cprintf('blue',   'Maximum Iterations: %d\n',MaxIteration);
       cprintf('blue',   'Iteration :  ');      
       while Step_Norm>=INFO_Optimization.Epsilon && Iter<INFO_Optimization.MaxIteration 
             X_All(Iter,:)=x0;
             [H_L ,F_L,E_Geo_L] = Quadratic_System_Matrixes_Calculator (INFO_L1);
             [H_R ,F_R,E_Geo_R] = Quadratic_System_Matrixes_Calculator (INFO_R1); 
             %----Normalizing and Weight applying----
             H_L=WL.*(H_L./Normalization_E.Geo_L0);
             F_L=WL.*(F_L./Normalization_E.Geo_L0);
             H_R=WR.*(H_R./Normalization_E.Geo_R0);
             F_R=WR.*(F_R./Normalization_E.Geo_R0);
             %----Combining--------------------------
             H_Combined=blkdiag(H_L , H_R); 
             F_Combined=[F_L;F_R];     
             %----Solve System-----------------------
             options = optimset('Display', 'off');
             x0=quadprog(H_Combined,F_Combined,A_InEq,b_InEq,A_Eq,b_Eq,Lb,Ub,[],options);  
             %----Update Controls--------------------        
             x0_L=x0(1:INFO_L1.N_Param,1);
             x0_R=x0(INFO_L1.N_Param+1:end,1);
             [INFO_L1.CPs,Step_Left] = Solution_Completion_and_CPs_Update_QP (x0_L,INFO_L1,INFO_Optimization);
             [INFO_R1.CPs,Step_Right] = Solution_Completion_and_CPs_Update_QP (x0_R,INFO_R1,INFO_Optimization);
             %-----------------
             [INFO_L1,INFO_R1]=Intersections_Finder(INFO_L1,INFO_R1);
             %-----------------
             [INFO_L1,INFO_R1]=Extremities_Finder_Varying(INFO_L1,INFO_R1);
             %-----------------
             Step_Norm=norm([Step_Left,Step_Right]);
             NORM(1,Iter)=Step_Norm;
             ERROR(1,Iter) = WL*(E_Geo_L./Normalization_E.Geo_L0)+WR*(E_Geo_R./Normalization_E.Geo_R0);%+WE*(E_Events./Normalization_E.Events0);
             Iter=Iter+1;
             if Iter>1
                for j=0:log10(Iter-1)
                    fprintf('\b');
                end
             end
             fprintf('%d', Iter);            
       end  
       cprintf('blue',   '\nStopping Criteria Satisfied\n');
       cprintf('blue',   'QP Is Finnished\n');

       [~,LOC]=min(ERROR(1,1:Iter-1));
       if LOC~=Iter-1
          x0=X_All(LOC,:)';
          x0_L=x0(1:INFO_L1.N_Param,1);
          x0_R=x0(INFO_L1.N_Param+1:end,1);
          [INFO_L1.CPs,~] = Solution_Completion_and_CPs_Update_QP (x0_L,INFO_L1,INFO_Optimization);
          [INFO_R1.CPs,~] = Solution_Completion_and_CPs_Update_QP (x0_R,INFO_R1,INFO_Optimization);
          %-----------------
          [INFO_L1,INFO_R1]=Intersections_Finder(INFO_L1,INFO_R1);
          %-----------------
          [INFO_L1,INFO_R1]=Extremities_Finder_Varying(INFO_L1,INFO_R1);
       end
             
end

end
