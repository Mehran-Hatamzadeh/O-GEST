function [Tk,Projections] = Find_Projection_On_Cubic_Bezier (Controls,Data_Bspline)
% ========================================================================
% Description: This function finds orthogonal projection of a group of data points (Data_Bspline) 
%              that fall within cubic Bezier area, which has 2*4 control points.
%              It first tries finding orthogonal projection and if fails,
%              fidns direct projection of each point of data matrix on the
%              Bezier curve. Data_Bspline here is a 2*M matrix.
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
if isempty(Data_Bspline)~=1
   P0=Controls(:,1);
   P1=Controls(:,2);
   P2=Controls(:,3);
   P3=Controls(:,4);
   %Orthogonal Projection Solving
   Co_t5= (3.*P0 - 9.*P1 + 9.*P2 - 3.*P3).*(P0 - 3.*P1 + 3.*P2 - P3);
   CO_T5= (sum(Co_t5)).*ones(width(Data_Bspline),1);
   Co_t4= - (6.*P0 - 12.*P1 + 6.*P2).*(P0 - 3.*P1 + 3.*P2 - P3) - (3.*P0 - 6.*P1 + 3.*P2).*(3.*P0 - 9.*P1 + 9.*P2 - 3.*P3);
   CO_T4= (sum(Co_t4)).*ones(width(Data_Bspline),1);
   Co_t3= (3.*P0 - 3.*P1).*(3.*P0 - 9.*P1 + 9.*P2 - 3.*P3) + (3.*P0 - 6.*P1 + 3.*P2).*(6.*P0 - 12.*P1 + 6.*P2) + (3.*P0 - 3.*P1).*(P0 - 3.*P1 + 3.*P2 - P3);
   CO_T3= (sum(Co_t3)).*ones(width(Data_Bspline),1);
   Co_t2= - (3.*P0 - 3.*P1).*(3.*P0 - 6.*P1 + 3.*P2) - (3.*P0 - 3.*P1).*(6.*P0 - 12.*P1 + 6.*P2) - (P0 - Data_Bspline).*(3.*P0 - 9.*P1 + 9.*P2 - 3.*P3);
   CO_T2= sum(Co_t2)';
   Co_t1= (3.*P0 - 3.*P1).^2 + (P0 - Data_Bspline).*(6.*P0 - 12.*P1 + 6.*P2);
   CO_T1= sum(Co_t1)';
   Co_t0= -(P0 - Data_Bspline).*(3.*P0 - 3.*P1);
   CO_T0= sum(Co_t0)';
   COEFFS=[CO_T5,CO_T4,CO_T3,CO_T2,CO_T1,CO_T0];
   ROOTS=NaN.*zeros(1,width(Data_Bspline)); %roots of orthogonal projection
   for i=1:1:width(Data_Bspline)
       Roots=roots(COEFFS(i,:));
       Roots=real(Roots(imag(Roots)>-1e-4 & imag(Roots)<1e-4));
       Roots=Roots(Roots>=-1e-4 & Roots<=1+1e-4);%roots of orthogonal projection
       if isempty(Roots)==1 %shift to direct projection if there is no root
          %Direct Projection Solving
          T_Point=Data_Bspline(1,i);
          P0x=Controls(1,1);
          P1x=Controls(1,2);
          P2x=Controls(1,3);
          P3x=Controls(1,4);
          Co_t3=3*P1x - P0x - 3*P2x + P3x ;
          Co_t2=3*P0x - 6*P1x + 3*P2x ;
          Co_t1=3*P1x - 3*P0x ;
          Co_t0=P0x - T_Point ;
          Roots=roots([Co_t3, Co_t2, Co_t1, Co_t0]);
          Roots=real(Roots(imag(Roots)>-1e-4 & imag(Roots)<1e-4));
          Roots=Roots(Roots>=-1e-4 & Roots<=1+1e-4); %roots of direct projection
          if isempty(Roots)==1 && P0(1,1)>Data_Bspline(1,i)
             Roots=0;
          elseif isempty(Roots)==1 && P0(1,1)<Data_Bspline(1,i)
              Roots=1;
          end
       end
       ROOTS(1,i)=Roots(1,1);
   end


   B0=(1-ROOTS).^3;
   B1=3.*ROOTS.*((1-ROOTS).^2);
   B2=3.*(ROOTS.^2).*(1-ROOTS);
   B3=ROOTS.^3;
   Projections =(B0.*P0)+(B1.*P1)+(B2.*P2)+(B3.*P3);
   Tk=ROOTS;
else
   Projections=[]; 
   Tk=[];
end
end