function [Setting]=Trend_Finder(Time,JointsDepth_L,JointsDepth_R,Setting)
% ========================================================================
% Description: This function detects whether the reference point is in front of
%              the subject or in the back and corrects the data if its in the back.
%              Upward: Reference in the back
%              Downward: Reference in the front
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
ML=zeros(1,width(JointsDepth_L));
for I=1:1:width(JointsDepth_L)
    Inf=polyfit(Time,JointsDepth_L(:,I),1);
    ML(1,I)=Inf(1,1);
end
MR=zeros(1,width(JointsDepth_R));
for I=1:1:width(JointsDepth_R)
    Inf=polyfit(Time,JointsDepth_R(:,I),1);
    MR(1,I)=Inf(1,1);
end
if width(ML(ML>0))==width(JointsDepth_L) && width(MR(MR>0))==width(JointsDepth_R)
    Setting.Direction="Upward";
else
    Setting.Direction="Downward";
end

Curves_Difference=JointsDepth_L(2:end-1,1)-JointsDepth_R(2:end-1,1);
Curves_Difference_Neg=Curves_Difference(Curves_Difference<0);
Curves_Difference_Pos=Curves_Difference(Curves_Difference>0);
if isempty(Curves_Difference_Neg) || isempty(Curves_Difference_Pos) || ( max([height(Curves_Difference_Neg),height(Curves_Difference_Pos)])/min([height(Curves_Difference_Neg),height(Curves_Difference_Pos)]) ) > 3
   Setting.Type="Without_Intersection";
   Min_Diff=min(abs(Curves_Difference));
   Max_Diff=max(abs(Curves_Difference));
   AV_Diff=(Min_Diff+Max_Diff)./2;
   Setting.Shift_Offset=AV_Diff;
    if JointsDepth_L(2,1)<JointsDepth_R(2,1)
        Setting.Lower="Left";        
    else
        Setting.Lower="Right";
    end
else
    Setting.Type="With_Intersection";
end

end