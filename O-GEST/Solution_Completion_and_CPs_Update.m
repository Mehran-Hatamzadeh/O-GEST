function    [CPs_Cycles] = Solution_Completion_and_CPs_Update (x0,Dim,INFO)
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
Ncp=INFO.Ncp;
CPs_Cycles=INFO.CPs;
N_Cycle=length(CPs_Cycles);
x0 = reshape(x0(:,1),[Dim,Ncp*N_Cycle]);
for i=1:1:N_Cycle    
    xx=x0(:, ((i-1)*Ncp +1):(i*Ncp));
    CPs_Cycles{1,i}=xx;
end
end
