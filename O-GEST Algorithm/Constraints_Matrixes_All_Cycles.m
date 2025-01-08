function [A_InEq,b_InEq,A_Eq,b_Eq] = Constraints_Matrixes_All_Cycles (Dim,INFO)
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
%----------
N_Cycle=length(CPs_Cycles);
%----------
X0=zeros(N_Cycle*Dim*Ncp,1);
for i=1:1:N_Cycle
    CPs=CPs_Cycles{1,i};
    q1=((i-1)*Ncp*Dim ) + 1;
    q2=i*Ncp*Dim;
    X0(q1:q2,1)=reshape(CPs,[1,Dim*Ncp])';
end
%-------- Time Inequalities -------------------------
IDS=1:2:(Dim*Ncp*N_Cycle);
A_Ineq_T=zeros((Ncp-1)*N_Cycle,Ncp*Dim*N_Cycle);
b_Ineq_T=zeros((Ncp-1)*N_Cycle,1);
for i=1:1:width(IDS)-1
    id1=IDS(1,i);
    id2=IDS(1,i+1);
    A_Ineq_T(i,id1)=+1;
    A_Ineq_T(i,id2)=-1;
    b_Ineq_T(i,1)=X0(id2,1)-X0(id1,1);
end
% %-------- Depth Inequalities -------------------------
if Ncp==4
   A_Ineq_D=zeros(1,Ncp*Dim*N_Cycle);
   b_Ineq_D=zeros(1,1);
   for i=1:1:N_Cycle
       ID=i;
       First=2+((i-1)*2*Ncp);
       Last=i*2*Ncp;   
       A_Ineq_D(ID,First(1,1))=-1;
       A_Ineq_D(ID,Last(1,1))=1;
       b_Ineq_D(ID,1)=X0(First(1,1),1)-X0(Last(1,1),1);       
   end
end
%-----------
if Ncp==5
   A_Ineq_D=zeros(2,Ncp*Dim*N_Cycle);
   b_Ineq_D=zeros(2,1);
   for i=1:1:N_Cycle
       ID=2*i;
       First=2+((i-1)*2*Ncp);
       Last=[((i)*2*Ncp)-4, i*2*Ncp];   
       A_Ineq_D(ID-1,First(1,1))=-1;
       A_Ineq_D(ID-1,Last(1,2))=1;
       b_Ineq_D(ID-1,1)=X0(First(1,1),1)-X0(Last(1,2),1);       
       A_Ineq_D(ID,Last(1,2))=-1;
       A_Ineq_D(ID,Last(1,1))=1;
       b_Ineq_D(ID,1)=X0(Last(1,2),1)-X0(Last(1,1),1);
   end
end
%--------------Inequality Constraints------------------
A_InEq=[A_Ineq_T;A_Ineq_D];
b_InEq=0*([b_Ineq_T;b_Ineq_D]);
%-------- Depth Equalities (G1) -----------------------
A_Eq_D1=zeros(2,Ncp*Dim*N_Cycle);
b_Eq_D1=zeros(2,1);
for i=1:1:N_Cycle
    ID=2*i;
    First=[2,4]+((i-1)*2*Ncp);
    Last=[(i*2*Ncp)-2,i*2*Ncp];   
    A_Eq_D1(ID-1,First(1,1))=1;
    A_Eq_D1(ID-1,First(1,2))=-1;
    b_Eq_D1(ID-1,1)=0; 
    A_Eq_D1(ID,Last(1,1))=1;
    A_Eq_D1(ID,Last(1,2))=-1;
    b_Eq_D1(ID,1)=0;  
end
%-------- Depth Equalities (Sections) ----------------
A_Eq_D2=zeros(1,Ncp*Dim*N_Cycle);
b_Eq_D2=zeros(1,1);
if N_Cycle>1
   for i=1:1:N_Cycle-1
       IDs=[i*Ncp*Dim , (i*Ncp*Dim) + 2];
       A_Eq_D2(i,IDs(1,1))=1;
       A_Eq_D2(i,IDs(1,2))=-1;
       b_Eq_D2(i,1)=0;
   end
end
%--------Depth Equalities
A_Eq=[A_Eq_D1;A_Eq_D2];
b_Eq=[b_Eq_D1;b_Eq_D2];
 
end