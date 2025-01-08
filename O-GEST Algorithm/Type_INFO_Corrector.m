function [INFO]=Type_INFO_Corrector(INFO,Setting)
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
INFO.Data=INFO.Data-Setting.Shift_Offset;
INFO.Intersections="Without_Intersections";
INFO.Line_Info="Without_Intersections_Line";
INFO.Interests(2,:)=INFO.Interests(2,:)-Setting.Shift_Offset;
for i=1:1:INFO.N_Sections
    SEC=INFO.Sections{1,i};
    SEC(:,2)=SEC(:,2)-Setting.Shift_Offset;
    INFO.Sections{1,i}=SEC;
    %---------------------
    CP=INFO.CPs{1,i};
    CP(2,:)=CP(2,:)-Setting.Shift_Offset;
    INFO.CPs{1,i}=CP;
    %---------------------
    Ext=INFO.Extremes{1,i};
    Ext(2,:)=Ext(2,:)-Setting.Shift_Offset;
    INFO.Extremes{1,i}=Ext;
end
end