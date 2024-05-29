function [Tk,Projections,Distances] = Find_Projection_On_Cubic_Bspline (Controls,Data_Bspline)
% ========================================================================
% Description: This function finds projection of a group of data points (Data_Bspline) 
%              that fall in B-Spline area. Inputs are the 2*N control points and
%              2*M data.
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
[~,Ncp]=size(Controls);

if Ncp==4 && isempty(Data_Bspline)~=1 %just 1 bezier
   [Tk,Projections] = Find_Projection_On_Cubic_Bezier (Controls,Data_Bspline);
   Distances=vecnorm(Data_Bspline - Projections);
elseif Ncp==5 && isempty(Data_Bspline)~=1 % 2 beziers
   [Beziers_Inside] = Beziers_Inside_Bspline (Controls); 
   [Tk1,Projections1] = Find_Projection_On_Cubic_Bezier (Beziers_Inside{1,1},Data_Bspline);
   [Tk2,Projections2] = Find_Projection_On_Cubic_Bezier (Beziers_Inside{1,2},Data_Bspline);
   Tk2=Tk2+1;
   Distances1=vecnorm(Data_Bspline - Projections1);
   Distances2=vecnorm(Data_Bspline - Projections2);
   Distances = min(Distances1,Distances2);
   Projections=Projections1;
   Projections(:,Distances==Distances2)=Projections2(:,Distances==Distances2);
   Tk=Tk1;
   Tk(:,Distances==Distances2)=Tk2(:,Distances==Distances2);
elseif isempty(Data_Bspline)==1
   Projections=[];
   Distances=[];
   Tk=[];
end
end

