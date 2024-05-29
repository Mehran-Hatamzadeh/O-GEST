function [INFO] = Initial_Control_Points (INFO)
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
Sections=INFO.Sections;
Ncp=INFO.Ncp;
Percentages=[5,35,65,95];
Percentages=Percentages./100;

if Ncp>4
    Percentages=[Percentages(1),linspace(Percentages(2),Percentages(3),(2+Ncp-4)),Percentages(4)];
end


CPs_Cycles=cell(1,length(Sections));

for i=1:1:length(Sections)
    Data=Sections{1,i};
    Time=Data(:,1);
    Depths=Data(:,2);
    samples=round(length(Time).*(Percentages))';
       
    Cps_T=Time(samples);
    Cps_D=Depths(samples);
    Cps_D(2,1)=Cps_D(1,1);
    Cps_D(end-1,1)=Cps_D(end,1);
    if Ncp>4
       for k=3:1:Ncp-2
           Cps_D(k,1)=Cps_D(end-1,1)-(0.25.*(Cps_D(2,1) - Cps_D(end-1,1)));
       end
    end
    CPs_Cycles{1,i}=[Cps_T,Cps_D];
end  

for i= 1:1:length(Sections)-1
    CPs=CPs_Cycles{1,i};
    CPs_next=CPs_Cycles{1,i+1};
    P0_next_D=CPs_next(1,2);
    CPs(end-1,2)=P0_next_D;
    CPs(end,2)=P0_next_D;
    CPs_Cycles{1,i}=CPs;
end

for i=1:1:length(Sections)
    CPs=CPs_Cycles{1,i};
    CPs_Cycles{1,i}=CPs';
end

INFO.CPs=CPs_Cycles;
end