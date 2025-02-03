function    [CPs_Cycles,Step] = Solution_Completion_and_CPs_Update_QP (x0,INFO,INFO_Optimization)
% ========================================================================
% Description: This function applies a damping on the newly obtained poisition
%              of control points and updates the previous control points.
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
Ncp=INFO.Ncp;
CPs_Cycles=INFO.CPs;
Weight=INFO_Optimization.Damping_Weight;

N_Cycle=length(CPs_Cycles);
Old_Cps=cell2mat(CPs_Cycles);
x0 = reshape(x0(:,1),[Dim,Ncp*N_Cycle]);
Step=x0-Old_Cps;
for i=1:1:N_Cycle
    CPs=CPs_Cycles{1,i};
    xx=x0(:, ((i-1)*Ncp +1):(i*Ncp));
    CPs_new=(Weight.*(xx-CPs))+CPs;
    CPs_Cycles{1,i}=CPs_new;
end
end
