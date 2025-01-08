function [Spatio_Temporals] = Spatio_Temporal_Calculator (Events)
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
Spatio_Temporals=[];
try
Stride_Lengths=zeros(1,width(Events.Location.Left_Foot_Strike)-1);
Stride_Times=zeros(1,width(Events.Location.Left_Foot_Strike)-1);
Speeds=zeros(1,width(Events.Location.Left_Foot_Strike)-1);
Swing_Percentages=zeros(1,width(Events.Location.Left_Foot_Strike)-1);
Stance_Percentages=zeros(1,width(Events.Location.Left_Foot_Strike)-1);
Step_Lengths=zeros(1,width(Events.Location.Left_Foot_Strike)-1);
Step_Times=zeros(1,width(Events.Location.Left_Foot_Strike)-1);
for i=1:1:width(Events.Location.Left_Foot_Strike)-1 
    Strike1=Events.Location.Left_Foot_Strike(:,i);
    Strike2=Events.Location.Left_Foot_Strike(:,i+1);
    Stride_Lengths(1,i)=abs(Strike2(2,1)-Strike1(2,1));
    Stride_Times(1,i)=abs(Strike2(1,1)-Strike1(1,1));
    Speeds(1,i)=Stride_Lengths(1,i)/Stride_Times(1,i);
    %-------
    Offs=Events.Location.Left_Foot_Off;
    Offs(:,Offs(1,:)<Strike1(1,1) | Offs(1,:)>Strike2(1,1))=[];
    Swing_Percentages(1,i)=100*((abs(Strike2(1,1)-Offs(1,1)))/Stride_Times(1,i));
    Stance_Percentages(1,i)=100-Swing_Percentages(1,i);
    %-------
    Strikes_Opposite=Events.Location.Right_Foot_Strike;
    Strikes_Opposite(:,Strikes_Opposite(1,:)<Strike1(1,1) | Strikes_Opposite(1,:)>Strike2(1,1))=[];
    Step_Lengths(1,i)=abs(Strikes_Opposite(2,1)-Strike2(2,1));
    Step_Times(1,i)=abs(Strikes_Opposite(1,1)-Strike2(1,1));
end
Stride_Length_Left=Stride_Lengths;
Stride_Time_Left=Stride_Times;
Step_Length_Left=Step_Lengths;
Step_Time_Left=Step_Times;
Speed_Left=Speeds;
Stance_Percentages_Left=Stance_Percentages;
Swing_Percentages_Left=Swing_Percentages;

%-----------------------------------------------------


Stride_Lengths=zeros(1,width(Events.Location.Right_Foot_Strike)-1);
Stride_Times=zeros(1,width(Events.Location.Right_Foot_Strike)-1);
Speeds=zeros(1,width(Events.Location.Right_Foot_Strike)-1);
Swing_Percentages=zeros(1,width(Events.Location.Left_Foot_Strike)-1);
Stance_Percentages=zeros(1,width(Events.Location.Left_Foot_Strike)-1);
Step_Lengths=zeros(1,width(Events.Location.Left_Foot_Strike)-1);
Step_Times=zeros(1,width(Events.Location.Left_Foot_Strike)-1);
for i=1:1:width(Events.Location.Right_Foot_Strike)-1 
    Strike1=Events.Location.Right_Foot_Strike(:,i);
    Strike2=Events.Location.Right_Foot_Strike(:,i+1);
    Stride_Lengths(1,i)=abs(Strike2(2,1)-Strike1(2,1));
    Stride_Times(1,i)=abs(Strike2(1,1)-Strike1(1,1));
    Speeds(1,i)=Stride_Lengths(1,i)/Stride_Times(1,i);
    %-------
    Offs=Events.Location.Right_Foot_Off;
    Offs(:,Offs(1,:)<Strike1(1,1) | Offs(1,:)>Strike2(1,1))=[];
    Swing_Percentages(1,i)=100*((abs(Strike2(1,1)-Offs(1,1)))/Stride_Times(1,i));
    Stance_Percentages(1,i)=100-Swing_Percentages(1,i);
    %-------
    Strikes_Opposite=Events.Location.Left_Foot_Strike;
    Strikes_Opposite(:,Strikes_Opposite(1,:)<Strike1(1,1) | Strikes_Opposite(1,:)>Strike2(1,1))=[];
    Step_Lengths(1,i)=abs(Strikes_Opposite(2,1)-Strike2(2,1));
    Step_Times(1,i)=abs(Strikes_Opposite(1,1)-Strike2(1,1));
end

Stride_Length_Right=Stride_Lengths;
Stride_Time_Right=Stride_Times;
Step_Length_Right=Step_Lengths;
Step_Time_Right=Step_Times;
Speed_Right=Speeds;
Stance_Percentages_Right=Stance_Percentages;
Swing_Percentages_Right=Swing_Percentages;
%-----------------------------------------------------

Spatio_Temporals.Overall_Gait_Speed=mean([Speed_Left,Speed_Right]);
Spatio_Temporals.Overall_Step_Length=mean([Step_Length_Left,Step_Length_Right]);
Spatio_Temporals.Overall_Step_Time=mean([Step_Time_Left,Step_Time_Right]);
Spatio_Temporals.Overall_Stride_Length=mean([Stride_Length_Left,Stride_Length_Right]);
Spatio_Temporals.Overall_Stride_Time=mean([Stride_Time_Left,Stride_Time_Right]);
Spatio_Temporals.Overall_Stance_Percentage=mean([Stance_Percentages_Left,Stance_Percentages_Right]);
Spatio_Temporals.Overall_Swing_Percentage=mean([Swing_Percentages_Left,Swing_Percentages_Right]);

Spatio_Temporals.Stride_Length_Left=Stride_Length_Left;
Spatio_Temporals.Stride_Time_Left=Stride_Time_Left;
Spatio_Temporals.Step_Length_Left=Step_Length_Left;
Spatio_Temporals.Step_Time_Left=Step_Time_Left;
Spatio_Temporals.Speed_Left=Speed_Left;
Spatio_Temporals.Stance_Percentages_Left=Stance_Percentages_Left;
Spatio_Temporals.Swing_Percentages_Left=Swing_Percentages_Left;

Spatio_Temporals.Stride_Length_Right=Stride_Length_Right;
Spatio_Temporals.Stride_Time_Right=Stride_Time_Right;
Spatio_Temporals.Step_Length_Right=Step_Length_Right;
Spatio_Temporals.Step_Time_Right=Step_Time_Right;
Spatio_Temporals.Speed_Right=Speed_Right;
Spatio_Temporals.Stance_Percentages_Right=Stance_Percentages_Right;
Spatio_Temporals.Swing_Percentages_Right=Swing_Percentages_Right;
catch
   Spatio_Temporals=[];
end

end