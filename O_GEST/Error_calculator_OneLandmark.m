function [Error]=Error_calculator_OneLandmark (x,INFO_L,INFO_R,INFO_Optimization,Normalization_E)
% ========================================================================
% Description: This function calculates the geometric error in each iteration
%              of optimization using the updated position of control points
%              given inside matrix x.
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




    
    