function [INFO_L,INFO_R]=Intersections_Finder(INFO_L,INFO_R)
% ========================================================================
% Description: This function the intersection points between left and right 
%              trajectories.             
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
N_Cycle_L=INFO_L.N_Cycle;
N_Cycle_R=INFO_R.N_Cycle;
CPs_Cycles_L=INFO_L.CPs;
CPs_Cycles_R=INFO_R.CPs;
IDs_L=INFO_L.IDs;
IDs_R=INFO_R.IDs;
CPS_L=cell2mat(CPs_Cycles_L);
CPS_R=cell2mat(CPs_Cycles_R);
%-----------------------------------------------------
STARTING_CPS_L=CPS_L(:,1:INFO_L.Ncp:width(CPS_L)-1);
ENDING_CPS_L=CPS_L(:,end);

STARTING_CPS_R=CPS_R(:,1:INFO_R.Ncp:width(CPS_R)-1);
ENDING_CPS_R=CPS_R(:,end);
%-----------------------------------------------------
if IDs_L.interests_remove_begin~=0
    STARTING_CPS_L(:,1:1:(IDs_L.interests_remove_begin/2))=[];
end
if IDs_R.interests_remove_begin~=0
    STARTING_CPS_R(:,1:1:(IDs_R.interests_remove_begin/2))=[];
end
if IDs_L.interests_remove_end~=0
    ENDING_CPS_L(:,1:1:(IDs_L.interests_remove_end/2))=[];
end
if IDs_R.interests_remove_end~=0
    ENDING_CPS_R(:,1:1:(IDs_R.interests_remove_end/2))=[];
end
Ints_L=[STARTING_CPS_L,ENDING_CPS_L];
Ints_R=[STARTING_CPS_R,ENDING_CPS_R];

Intersection_L=NaN.*ones(2,N_Cycle_L+1);
for i=1:1:width(Ints_L)
    Point=Ints_L(:,i);
    Ps=CPs_Cycles_R{1,i};
    [Beziers_Inside] = Beziers_Inside_Bspline (Ps);
    for j=1:1:width(Beziers_Inside)
        Ps=Beziers_Inside{1,j};
        if Point(2,1)>= min(Ps(2,:)) && Point(2,1)<= max(Ps(2,:))
           P0d=Ps(2,1);
           P1d=Ps(2,2);
           P2d=Ps(2,3);
           P3d=Ps(2,4);
           Co_t3=P0d - 3*P1d + 3*P2d - P3d;
           Co_t2=6*P1d - 3*P0d - 3*P2d;
           Co_t1=3*P0d - 3*P1d;
           Co_t0=Point(2,1) - P0d;
           Roots=roots([Co_t3,Co_t2,Co_t1,Co_t0]);
           Roots=real(Roots(imag(Roots)>-1e-4 & imag(Roots)<1e-4));
           Roots=Roots(Roots>=-1e-4 & Roots<=1+1e-4);
           Roots(:,isnan(Roots))=[];
           Roots=unique(Roots,'stable');
           if isempty(Roots)==1
              Intersection_L(:,i) = NaN;
           else
              t=Roots(1,1);
              B0=(1-t)^3;
              B1=3*t*((1-t)^2);
              B2=3*(t^2)*(1-t);
              B3=t^3;
             Intersection_L(:,i) =(B0*Ps(:,1))+(B1*Ps(:,2))+(B2*Ps(:,3))+(B3*Ps(:,4));
          end
        end
    end    
end
Intersection_L(:,isnan(Intersection_L(1,:)))=[];

Intersection_R=NaN.*ones(2,N_Cycle_R+1);
for i=1:1:width(Ints_R)
    Point=Ints_R(:,i);
    Ps=CPs_Cycles_L{1,i};
    [Beziers_Inside] = Beziers_Inside_Bspline (Ps);   
    for j=1:1:width(Beziers_Inside)
        Ps=Beziers_Inside{1,j};
        if Point(2,1)>= min(Ps(2,:)) && Point(2,1)<= max(Ps(2,:))
           P0d=Ps(2,1);
           P1d=Ps(2,2);
           P2d=Ps(2,3);
           P3d=Ps(2,4);
           Co_t3=P0d - 3*P1d + 3*P2d - P3d;
           Co_t2=6*P1d - 3*P0d - 3*P2d;
           Co_t1=3*P0d - 3*P1d;
           Co_t0=Point(2,1) - P0d;
           Roots=roots([Co_t3,Co_t2,Co_t1,Co_t0]);
           Roots=real(Roots(imag(Roots)>-1e-4 & imag(Roots)<1e-4));
           Roots=Roots(Roots>=-1e-4 & Roots<=1+1e-4);
           Roots(:,isnan(Roots))=[];
           Roots=unique(Roots,'stable');
           if isempty(Roots)==1
              Intersection_R(:,i) = NaN;
           else
              t=Roots(1,1);
              B0=(1-t)^3;
              B1=3*t*((1-t)^2);
              B2=3*(t^2)*(1-t);
              B3=t^3;
             Intersection_R(:,i) =(B0*Ps(:,1))+(B1*Ps(:,2))+(B2*Ps(:,3))+(B3*Ps(:,4));
          end
        end
    end    
end
Intersection_R(:,isnan(Intersection_R(1,:)))=[];

INFO_L.Intersections=Intersection_L;
INFO_R.Intersections=Intersection_R;
end