function [Error]=Geometric_Error_calculator (INFO)
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
Cycles_Data=INFO.Sections;
CPs_Cycles=INFO.CPs;
N_Cycle=length(Cycles_Data);
E_All=zeros(1,N_Cycle);
for i=1:1:N_Cycle
    Controls=CPs_Cycles{1,i}; 
    raw_data=Cycles_Data{1,i};
    Data=[raw_data(:,1),raw_data(:,2)]';
    Data_Line1=Data(:,Data(1,:)<Controls(1,1));
    Data_Line2=Data(:,Data(1,:)>Controls(1,end));
    Data_Bspline=Data;
    Data_Bspline(:,1:1:width(Data_Line1))=[];
    Data_Bspline(:,end-width(Data_Line2)+1:1:end)=[];
    %---------------Inside Line1 and Line2---------------------
    E_Line1=abs(Data_Line1(2,:)-Controls(2,1));
    E_Line2=abs(Data_Line2(2,:)-Controls(2,end));
    %---------------Inside Cubic B-Spline----------------------
    [~,~,Distances] = Find_Projection_On_Cubic_Bspline (Controls,Data_Bspline);
    E_BSpline = Distances;
    %----------------------------------------------------------
    E_All(1,i)=sum(E_Line1)+sum(E_Line2)+sum(E_BSpline);
end
Error=sum(E_All);
end