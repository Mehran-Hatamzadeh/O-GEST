function [Events_Location,Events_Time] = Events_Finder (INFO_L1,INFO_R1,INFO_L2,INFO_R2,INFO_L3,INFO_R3,Setting)
% ========================================================================
% Description: This function extracts the events according to temporal sequencing
%              order of extremities obtained on trajectories of each foot landmarks.
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
if ~isempty(INFO_L1) && ~isempty(INFO_R1)
   Interests_L1=INFO_L1.Interests;
   Interests_R1=INFO_R1.Interests;
   GC_L1=Interests_L1(:,3:4:width(Interests_L1));
   GC_R1=Interests_R1(:,3:4:width(Interests_R1));
   SW_L1=Interests_L1(:,2:4:width(Interests_L1));
   SW_R1=Interests_R1(:,2:4:width(Interests_R1));
end
%-------------------------------------------------------
if ~isempty(INFO_L2) && ~isempty(INFO_R2)
   Interests_L2=INFO_L2.Interests;
   Interests_R2=INFO_R2.Interests;
   GC_L2=Interests_L2(:,3:4:width(Interests_L2));
   GC_R2=Interests_R2(:,3:4:width(Interests_R2));
   SW_L2=Interests_L2(:,2:4:width(Interests_L2));
   SW_R2=Interests_R2(:,2:4:width(Interests_R2));
else
   GC_L2=NaN.*ones(1,width(GC_L1));
   GC_R2=NaN.*ones(1,width(GC_R1));
   SW_L2=NaN.*ones(1,width(GC_L1));
   SW_R2=NaN.*ones(1,width(GC_R1)); 
end
%-------------------------------------------------------
if ~isempty(INFO_L3) && ~isempty(INFO_R3)
   Interests_L3=INFO_L3.Interests;
   Interests_R3=INFO_R3.Interests;
   GC_L3=Interests_L3(:,3:4:width(Interests_L3));
   GC_R3=Interests_R3(:,3:4:width(Interests_R3));
   SW_L3=Interests_L3(:,2:4:width(Interests_L3));
   SW_R3=Interests_R3(:,2:4:width(Interests_R3));
else
   GC_L3=NaN.*ones(1,width(GC_L1));
   GC_R3=NaN.*ones(1,width(GC_R1));
   SW_L3=NaN.*ones(1,width(GC_L1));
   SW_R3=NaN.*ones(1,width(GC_R1)); 
end
%-------------------------------------------------------
GC_L=NaN.*ones(2,width(GC_L1)); 

for i=1:1:width(GC_L1)
   [~,Loc]=min([GC_L1(1,i),GC_L2(1,i),GC_L3(1,i)]);
   if Loc==1
       GC_L(:,i)=GC_L1(:,i);
   elseif Loc==2
       GC_L(:,i)=GC_L2(:,i);
   elseif Loc==3
       GC_L(:,i)=GC_L3(:,i);
   end
end
    
GC_R=NaN.*ones(2,width(GC_R1)); 

for i=1:1:width(GC_R1)
   [~,Loc]=min([GC_R1(1,i),GC_R2(1,i),GC_R3(1,i)]);
   if Loc==1
       GC_R(:,i)=GC_R1(:,i);
   elseif Loc==2
       GC_R(:,i)=GC_R2(:,i);
   elseif Loc==3
       GC_R(:,i)=GC_R3(:,i);
   end
end

%-------------------------------------------------------
SW_L=NaN.*ones(2,width(SW_L1)); 

for i=1:1:width(SW_L1)
   [~,Loc]=max([SW_L1(1,i),SW_L2(1,i),SW_L3(1,i)]);
   if Loc==1
       SW_L(:,i)=SW_L1(:,i);
   elseif Loc==2
       SW_L(:,i)=SW_L2(:,i);
   elseif Loc==3
       SW_L(:,i)=SW_L3(:,i);
   end
end

SW_R=NaN.*ones(2,width(SW_R1)); 

for i=1:1:width(SW_R1)
   [~,Loc]=max([SW_R1(1,i),SW_R2(1,i),SW_R3(1,i)]);
   if Loc==1
       SW_R(:,i)=SW_R1(:,i);
   elseif Loc==2
       SW_R(:,i)=SW_R2(:,i);
   elseif Loc==3
       SW_R(:,i)=SW_R3(:,i);
   end
end

Events_Time.Left_Foot_Strike=GC_L(1,:);
Events_Time.Right_Foot_Strike=GC_R(1,:);
Events_Time.Left_Foot_Off=SW_L(1,:);
Events_Time.Right_Foot_Off=SW_R(1,:); 

Events_Location.Left_Foot_Strike=GC_L;
Events_Location.Right_Foot_Strike=GC_R;
Events_Location.Left_Foot_Off=SW_L;
Events_Location.Right_Foot_Off=SW_R;

if Setting.Direction=="Upward"
   Events_Location.Left_Foot_Strike(2,:)=-GC_L(2,:);
   Events_Location.Right_Foot_Strike(2,:)=-GC_R(2,:);
   Events_Location.Left_Foot_Off(2,:)=-SW_L(2,:);
   Events_Location.Right_Foot_Off(2,:)=-SW_R(2,:); 
end


end