function [Basis_Fun] = Cubic_Bspline_Basis_Function (Ncp)
% ========================================================================
% Description: This function provides the basis function of a Cubic B-Spline
%              by defining the number of control points (Ncp) and using
%              open uniform knot vectors with multiplicity.
%              In the function of spmak, utilizing [1,0,0,0 ...] will give first base (N0),
%              [0,1,0,0 ...] will give second base (N1),
%              [0,0,1,0 ...] will give second base (N2),
%              and etc.
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
Knots = [ zeros(1,4) , 1:1:Ncp-4 , zeros(1,4)+(Ncp-3)];
for i=0:1:Ncp-1
    CP_V = zeros(1,Ncp);
    CP_V(1,i+1)=1;
    Basis_Fun(1,i+1)=spmak(Knots,CP_V);
end
end
