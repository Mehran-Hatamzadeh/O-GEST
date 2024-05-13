function [Normalization_E]=Normalization_Error_calculator_OneLandmark (x0,INFO_L,INFO_R)
% ========================================================================
% Description: This function calculates the geometric error to be used in
%              normalization of error of each iteration of optimization.             
% ========================================================================
Dim=2;
%-----------------------------------
x_L=x0(1:INFO_L.N_Param,1);
x_R=x0(INFO_L.N_Param+1:end,1);
[INFO_L.CPs] = Solution_Completion_and_CPs_Update (x_L,Dim,INFO_L);
[INFO_R.CPs] = Solution_Completion_and_CPs_Update (x_R,Dim,INFO_R);
%-----------------
[Error_Geo_L]=Geometric_Error_calculator (INFO_L);        
[Error_Geo_R]=Geometric_Error_calculator (INFO_R);
%-----------------
Normalization_E.Geo_L0=Error_Geo_L;
Normalization_E.Geo_R0=Error_Geo_R;
end
