function [Error]=Error_calculator_OneLandmark (x,INFO_L,INFO_R,INFO_Optimization,Normalization_E)
% ========================================================================
% Description: This function calculates the geometric error in each iteration
%              of optimization using the updated position of control points
%              given inside matrix x.
% ========================================================================
% Developer:Mehran Hatamzadeh
%           Universite Cote d'Azur, LAMHESS, INRIA
% -------------------------------------------------------------------------
Dim=2;
x_L=x(1:INFO_L.N_Param,1);
x_R=x(INFO_L.N_Param+1:end,1);
[INFO_L.CPs] = Solution_Completion_and_CPs_Update (x_L,Dim,INFO_L);
[INFO_R.CPs] = Solution_Completion_and_CPs_Update (x_R,Dim,INFO_R);
%-----------------------------------
[Error_Geo_L]=Geometric_Error_calculator (INFO_L);        
[Error_Geo_R]=Geometric_Error_calculator (INFO_R);
%-----------------
WL=INFO_Optimization.Optimization_Weights(1,1);
WR=INFO_Optimization.Optimization_Weights(1,2);
Error=(WL.*(Error_Geo_L./Normalization_E.Geo_L0)) + (WR.*(Error_Geo_R./Normalization_E.Geo_R0));
end




    
    