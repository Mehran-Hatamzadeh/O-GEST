function [INFO_L,INFO_R]=Extremities_Finder(INFO_L,INFO_R,Indic)
% ========================================================================
% Description: This function finds extremities of B-Splines of each model
%              using the gait-dependent thresholds with optimal coefficients
%              in foot strike or foot off.
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
if INFO_L.Time(1,1)<INFO_R.Time(1,1)
    STARTING="Left";
else
    STARTING="Right";
end
if INFO_L.Time(end,1)<INFO_R.Time(end,1)
    ENDING="Right";
else
    ENDING="Left";
end
INTS_L=INFO_L.Intersections;
INTS_R=INFO_R.Intersections;
if STARTING=="Right"
    first=[INFO_R.Time(1,1);INFO_R.Data(1,1)];
    INTS_R=[first,INTS_R]; 
else
    first=[INFO_L.Time(1,1);INFO_L.Data(1,1)];
    INTS_L=[first,INTS_L]; 
end

if ENDING=="Left"
    last=[INFO_L.Time(end,1);INFO_L.Data(end,1)];
    INTS_L=[INTS_L,last];  
else
    last=[INFO_R.Time(end,1);INFO_R.Data(end,1)];
    INTS_R=[INTS_R,last]; 
end
 
CO_S_FO=0.1787;
CO_FO=-0.4887;

CO_S_FS=0.323;
CO_FS=0.077;

CO_S_FS5=0.5304;
CO_FS5=0.4871;
%===================================================================================
Extremes_Tk_L=cell(1,N_Cycle_L);
Extremes_L=cell(1,N_Cycle_L);
Interests_L=[];
for i=1:1:N_Cycle_L
    CPs_L=CPs_Cycles_L{1,i};
    if CPs_L(2,end)>CPs_L(2,1)
       CPs_L(2,:) = - CPs_L(2,:);
    end
    [Beziers_Inside] = Beziers_Inside_Bspline (CPs_L);
    Ext=[];
    Ext_tk=[];
    
    Section=INFO_L.Sections{1,i}'; 
    if Section(2,end)>Section(2,1)
       Section(2,:) = - Section(2,:);
    end
    Section_Speed=(Section(2,2:end)-Section(2,1:end-1))./(Section(1,2:end)-Section(1,1:end-1));
    Section_Speed_Total=Section_Speed;
    Section(:,Section(1,:)<=CPs_L(1,1) | Section(1,:)>=CPs_L(1,end))=[];
    Section_Speed=(Section(2,2:end)-Section(2,1:end-1))./(Section(1,2:end)-Section(1,1:end-1));

    if Indic=="FO"
       FO_Line_Speed=CO_S_FO*(mean(Section_Speed))+CO_FO*std(Section_Speed);
       if abs(mean(Section_Speed_Total))<1.2 && abs(mean(Section_Speed_Total))>0.8
           FO_Line_Speed= mean(Section_Speed_Total);
       end
       T1= INTS_L(1,i);
       D1= INTS_L(2,i);
       T2= INTS_L(1,i+1);
       D2New=D1+((T2-T1)*FO_Line_Speed);
    elseif Indic=="FS"
           FS_Line_Speed= CO_S_FS*mean(Section_Speed)+CO_FS*std(Section_Speed); 
           if abs(mean(Section_Speed_Total))<1.1 && abs(mean(Section_Speed_Total))>0.9
              FS_Line_Speed= mean(Section_Speed_Total);
           end
        T1= INTS_L(1,i);
        D1= INTS_L(2,i);
        T2= INTS_L(1,i+1);
        D2New=D1+((T2-T1)*FS_Line_Speed);
    end
    
    LineVector=[T2-T1 ; D2New-D1];
    LineX=LineVector(1,1);
    LineY=LineVector(2,1);
    for j=1:1:length(Beziers_Inside) 
        Bezier=Beziers_Inside{1,j};
        P0x=Bezier(1,1);
        P1x=Bezier(1,2);
        P2x=Bezier(1,3);
        P3x=Bezier(1,4);
        P0y=Bezier(2,1);
        P1y=Bezier(2,2);
        P2y=Bezier(2,3);
        P3y=Bezier(2,4);
        Co_t2= LineX*(3*P0y - 9*P1y + 9*P2y - 3*P3y) - LineY*(3*P0x - 9*P1x + 9*P2x - 3*P3x);
        Co_t1= LineY*(6*P0x - 12*P1x + 6*P2x) - LineX*(6*P0y - 12*P1y + 6*P2y);
        Co_t0= LineX*(3*P0y - 3*P1y) - LineY*(3*P0x - 3*P1x);
        Roots=roots([Co_t2,Co_t1,Co_t0]);
        Roots=real(Roots(imag(Roots)>-1e-4 & imag(Roots)<1e-4));
        Roots=Roots(Roots>=-1e-3 & Roots<=1+1e-3);
        Roots(:,isnan(Roots))=[];
        Roots=unique(Roots,'stable')';
        Roots=sort(Roots,2);
        %----------------------------------------------        
        if length(Beziers_Inside)==1 && width(Roots)~=2
           if isempty(Roots)==1
              Roots=[0.2,0.8];
           end
           if Roots(1,1)<0.5
              Roots(1,2)=0.8;
           else
              Roots(1,2)=Roots(1,1);
              Roots(1,1)=0.2;
           end
        end
        if length(Beziers_Inside)==2 && j==1 && width(Roots)~=1
           if isempty(Roots)==1
              Roots=0.2;
           else
            Roots=Roots(1,1);
           end
        end
        if length(Beziers_Inside)==2 && j==2 && width(Roots)~=1
            if isempty(Roots)==1
              Roots=0.8;
           else
            Roots=Roots(1,end);
           end
        end 
        t=sort(Roots);
        B0=(1-t).^3;
        B1=3.*t.*((1-t).^2);
        B2=3.*(t.^2).*(1-t);
        B3=t.^3;
        Ext=[Ext,(B0.*Bezier(:,1))+(B1.*Bezier(:,2))+(B2.*Bezier(:,3))+(B3.*Bezier(:,4))];
        if length(Beziers_Inside)==2 && j==2
           Roots(1,1)=Roots(1,1)+1;
        end
        Ext_tk=[Ext_tk,Roots];
     end
     
    Extremes_Tk_L{1,i}=Ext_tk;
    Extremes_L{1,i}=Ext;
    Interests_L=[Interests_L,CPs_L(:,1),Ext,CPs_L(:,end)];
end
%===================================================================================
Extremes_Tk_R=cell(1,N_Cycle_R);
Extremes_R=cell(1,N_Cycle_R);
Interests_R=[];
for i=1:1:N_Cycle_R
    CPs_R=CPs_Cycles_R{1,i};
    if CPs_R(2,end)>CPs_R(2,1)
       CPs_R(2,:) = - CPs_R(2,:);
    end
    [Beziers_Inside] = Beziers_Inside_Bspline (CPs_R);
    Ext=[];
    Ext_tk=[];
    
    Section=INFO_R.Sections{1,i}'; 
    if Section(2,end)>Section(2,1)
       Section(2,:) = - Section(2,:);
    end
     
    Section_Speed=(Section(2,2:end)-Section(2,1:end-1))./(Section(1,2:end)-Section(1,1:end-1));
    Section_Speed_Total=Section_Speed;
    Section(:,Section(1,:)<=CPs_R(1,1) | Section(1,:)>=CPs_R(1,end))=[];
    Section_Speed=(Section(2,2:end)-Section(2,1:end-1))./(Section(1,2:end)-Section(1,1:end-1));

    if Indic=="FO"
       FO_Line_Speed=CO_S_FO*(mean(Section_Speed))+CO_FO*std(Section_Speed);
       if abs(mean(Section_Speed_Total))<1.2 && abs(mean(Section_Speed_Total))>0.8
           FO_Line_Speed= mean(Section_Speed_Total);
       end
       T1= INTS_R(1,i);
       D1= INTS_R(2,i);
       T2= INTS_R(1,i+1);
       D2New=D1+((T2-T1)*FO_Line_Speed);
    elseif Indic=="FS" 
           FS_Line_Speed= CO_S_FS*mean(Section_Speed)+CO_FS*std(Section_Speed); 
           if abs(mean(Section_Speed_Total))<1.1 && abs(mean(Section_Speed_Total))>0.9
              FS_Line_Speed= mean(Section_Speed_Total);
           end
        T1= INTS_R(1,i);
        D1= INTS_R(2,i);
        T2= INTS_R(1,i+1);
        D2New=D1+((T2-T1)*FS_Line_Speed);
    end
   
    LineVector=[T2-T1 ; D2New-D1];
    LineX=LineVector(1,1);
    LineY=LineVector(2,1);
    for j=1:1:length(Beziers_Inside) 
        Bezier=Beziers_Inside{1,j};
        P0x=Bezier(1,1);
        P1x=Bezier(1,2);
        P2x=Bezier(1,3);
        P3x=Bezier(1,4);
        P0y=Bezier(2,1);
        P1y=Bezier(2,2);
        P2y=Bezier(2,3);
        P3y=Bezier(2,4);
        Co_t2= LineX*(3*P0y - 9*P1y + 9*P2y - 3*P3y) - LineY*(3*P0x - 9*P1x + 9*P2x - 3*P3x);
        Co_t1= LineY*(6*P0x - 12*P1x + 6*P2x) - LineX*(6*P0y - 12*P1y + 6*P2y);
        Co_t0= LineX*(3*P0y - 3*P1y) - LineY*(3*P0x - 3*P1x);
        Roots=roots([Co_t2,Co_t1,Co_t0]);
        Roots=real(Roots(imag(Roots)>-1e-4 & imag(Roots)<1e-4));
        Roots=Roots(Roots>=-1e-3 & Roots<=1+1e-3);
        Roots(:,isnan(Roots))=[];
        Roots=unique(Roots,'stable')';
        Roots=sort(Roots);
        %----------------------------------------------        
        if length(Beziers_Inside)==1 && width(Roots)~=2
           if isempty(Roots)==1
              Roots=[0.2,0.8];
           end
           if Roots(1,1)<0.5
              Roots(1,2)=0.8;
           else
              Roots(1,2)=Roots(1,1);
              Roots(1,1)=0.2;
           end
        end
        if length(Beziers_Inside)==2 && j==1 && width(Roots)~=1
           if isempty(Roots)==1
              Roots=0.2;
           else
            Roots=Roots(1,1);
           end
        end
        if length(Beziers_Inside)==2 && j==2 && width(Roots)~=1
            if isempty(Roots)==1
              Roots=0.8;
           else
            Roots=Roots(1,end);
           end
        end 
        t=sort(Roots);
        B0=(1-t).^3;
        B1=3.*t.*((1-t).^2);
        B2=3.*(t.^2).*(1-t);
        B3=t.^3;
        Ext=[Ext,(B0.*Bezier(:,1))+(B1.*Bezier(:,2))+(B2.*Bezier(:,3))+(B3.*Bezier(:,4))];
        if length(Beziers_Inside)==2 && j==2
           Roots(1,1)=Roots(1,1)+1;
        end
        Ext_tk=[Ext_tk,Roots];
     end
 
    Extremes_Tk_R{1,i}=Ext_tk;
    Extremes_R{1,i}=Ext;
    Interests_R=[Interests_R,CPs_R(:,1),Ext,CPs_R(:,end)];
end
%===================================================================================

Extremes_Tk_L_INV=cell(1,N_Cycle_L);
Extremes_L_INV=cell(1,N_Cycle_L);
if INFO_L.Ncp==5 && INFO_L.Intensity=="Intense" && Indic=="FS"
Interests_L_INV=[];
for i=1:1:N_Cycle_L
    CPs_L=CPs_Cycles_L{1,i};
    if CPs_L(2,end)>CPs_L(2,1)
       CPs_L(2,:) = - CPs_L(2,:);
    end
    [Beziers_Inside] = Beziers_Inside_Bspline (CPs_L);
    Ext=[];
    Ext_tk=[];
   
    Section=INFO_L.Sections{1,i}'; 
    if Section(2,end)>Section(2,1)
       Section(2,:) = - Section(2,:);
    end 
    Section_Speed=(Section(2,2:end)-Section(2,1:end-1))./(Section(1,2:end)-Section(1,1:end-1));
    Section_Speed_Total=Section_Speed;
    Section(:,Section(1,:)<=CPs_L(1,1) | Section(1,:)>=CPs_L(1,end))=[];
    Section_Speed=(Section(2,2:end)-Section(2,1:end-1))./(Section(1,2:end)-Section(1,1:end-1));
     
    FS_Line_Speed= CO_S_FS5*mean(Section_Speed)+CO_FS5*std(Section_Speed); 
    if abs(mean(Section_Speed_Total))<1.2 && abs(mean(Section_Speed_Total))>0.8
       FS_Line_Speed= mean(Section_Speed_Total);
    end
    T1= INTS_L(1,i);
    D1= INTS_L(2,i);
    T2= INTS_L(1,i+1);
    D2New=D1+((T2-T1)*FS_Line_Speed);
  
    LineVector=[T2-T1 ; D2New-D1];
    LineX=LineVector(1,1);
    LineY=-LineVector(2,1);
    for j=1:1:length(Beziers_Inside) 
        Bezier=Beziers_Inside{1,j};
        P0x=Bezier(1,1);
        P1x=Bezier(1,2);
        P2x=Bezier(1,3);
        P3x=Bezier(1,4);
        P0y=Bezier(2,1);
        P1y=Bezier(2,2);
        P2y=Bezier(2,3);
        P3y=Bezier(2,4);
        Co_t2= LineX*(3*P0y - 9*P1y + 9*P2y - 3*P3y) - LineY*(3*P0x - 9*P1x + 9*P2x - 3*P3x);
        Co_t1= LineY*(6*P0x - 12*P1x + 6*P2x) - LineX*(6*P0y - 12*P1y + 6*P2y);
        Co_t0= LineX*(3*P0y - 3*P1y) - LineY*(3*P0x - 3*P1x);
        Roots=roots([Co_t2,Co_t1,Co_t0]);
        Roots=real(Roots(imag(Roots)>-1e-4 & imag(Roots)<1e-4));
        Roots=Roots(Roots>=-1e-3 & Roots<=1+1e-3);
        Roots(:,isnan(Roots))=[];
        Roots=unique(Roots,'stable')';
        Roots=sort(Roots);
        %----------------------------------------------        
        if length(Beziers_Inside)==1 && width(Roots)~=2
           if isempty(Roots)==1
              Roots=[0.2,0.8];
           end
           if Roots(1,1)<0.5
              Roots(1,2)=0.8;
           else
              Roots(1,2)=Roots(1,1);
              Roots(1,1)=0.2;
           end
        end
        if length(Beziers_Inside)==2 && j==1 && width(Roots)~=1
           if isempty(Roots)==1
              Roots=0.2;
           else
            Roots=Roots(1,1);
           end
        end
        if length(Beziers_Inside)==2 && j==2 && width(Roots)~=1
            if isempty(Roots)==1
              Roots=0.6;
           else
            Roots=Roots(1,end);
           end
        end 
        t=sort(Roots);
        B0=(1-t).^3;
        B1=3.*t.*((1-t).^2);
        B2=3.*(t.^2).*(1-t);
        B3=t.^3;
        Ext=[Ext,(B0.*Bezier(:,1))+(B1.*Bezier(:,2))+(B2.*Bezier(:,3))+(B3.*Bezier(:,4))];
        if length(Beziers_Inside)==2 && j==2
           Roots(1,1)=Roots(1,1)+1;
        end
        Ext_tk=[Ext_tk,Roots];
    end
    Extremes_Tk_L_INV{1,i}=Ext_tk;
    Extremes_L_INV{1,i}=Ext;
    Interests_L_INV=[Interests_L_INV,CPs_L(:,1),Ext,CPs_L(:,end)];
end   
for i=1:1:width(Extremes_L)
                        exts=Extremes_L{1,i};
                        exts_new=Extremes_L_INV{1,i};
                        exts(:,2)=exts_new(:,2);
                        Extremes_L{1,i}=exts;
                        %------
                        tks=Extremes_Tk_L{1,i};
                        tks_new=Extremes_Tk_L_INV{1,i};
                        tks(:,2)=tks_new(:,2);
                        Extremes_Tk_L{1,i}=tks;
                        %------
                        Interests_L(:,(4*i)-1) = Interests_L_INV (:,(4*i)-1);        
end
end


%===================================================================================
Extremes_Tk_R_INV=cell(1,N_Cycle_R);
Extremes_R_INV=cell(1,N_Cycle_R);
if INFO_R.Ncp==5 && INFO_R.Intensity=="Intense" && Indic=="FS"
Interests_R_INV=[];
for i=1:1:N_Cycle_R
    CPs_R=CPs_Cycles_R{1,i};
    if CPs_R(2,end)>CPs_R(2,1)
       CPs_R(2,:) = - CPs_R(2,:);
    end
    [Beziers_Inside] = Beziers_Inside_Bspline (CPs_R);
    Ext=[];
    Ext_tk=[];
   
    Section=INFO_R.Sections{1,i}'; 
    if Section(2,end)>Section(2,1)
       Section(2,:) = - Section(2,:);
    end 
    Section_Speed=(Section(2,2:end)-Section(2,1:end-1))./(Section(1,2:end)-Section(1,1:end-1));
    Section_Speed_Total=Section_Speed;
    Section(:,Section(1,:)<=CPs_R(1,1) | Section(1,:)>=CPs_R(1,end))=[];
    Section_Speed=(Section(2,2:end)-Section(2,1:end-1))./(Section(1,2:end)-Section(1,1:end-1));
    
    FS_Line_Speed= CO_S_FS5*mean(Section_Speed)+CO_FS5*std(Section_Speed); 
    if abs(mean(Section_Speed_Total))<1.2 && abs(mean(Section_Speed_Total))>0.8
       FS_Line_Speed= mean(Section_Speed_Total);
    end
        T1= INTS_R(1,i);
        D1= INTS_R(2,i);
        T2= INTS_R(1,i+1);
        D2New=D1+((T2-T1)*FS_Line_Speed);
    
    LineVector=[T2-T1 ; D2New-D1];
    LineX=LineVector(1,1);
    LineY=-LineVector(2,1);
    for j=1:1:length(Beziers_Inside) 
        Bezier=Beziers_Inside{1,j};
        P0x=Bezier(1,1);
        P1x=Bezier(1,2);
        P2x=Bezier(1,3);
        P3x=Bezier(1,4);
        P0y=Bezier(2,1);
        P1y=Bezier(2,2);
        P2y=Bezier(2,3);
        P3y=Bezier(2,4);
        Co_t2= LineX*(3*P0y - 9*P1y + 9*P2y - 3*P3y) - LineY*(3*P0x - 9*P1x + 9*P2x - 3*P3x);
        Co_t1= LineY*(6*P0x - 12*P1x + 6*P2x) - LineX*(6*P0y - 12*P1y + 6*P2y);
        Co_t0= LineX*(3*P0y - 3*P1y) - LineY*(3*P0x - 3*P1x);
        Roots=roots([Co_t2,Co_t1,Co_t0]);
        Roots=real(Roots(imag(Roots)>-1e-4 & imag(Roots)<1e-4));
        Roots=Roots(Roots>=-1e-3 & Roots<=1+1e-3);
        Roots(:,isnan(Roots))=[];
        Roots=unique(Roots,'stable')';
        Roots=sort(Roots);
        %----------------------------------------------        
        if length(Beziers_Inside)==1 && width(Roots)~=2
           if isempty(Roots)==1
              Roots=[0.2,0.8];
           end
           if Roots(1,1)<0.5
              Roots(1,2)=0.8;
           else
              Roots(1,2)=Roots(1,1);
              Roots(1,1)=0.2;
           end
        end
        if length(Beziers_Inside)==2 && j==1 && width(Roots)~=1
           if isempty(Roots)==1
              Roots=0.2;
           else
            Roots=Roots(1,1);
           end
        end
        if length(Beziers_Inside)==2 && j==2 && width(Roots)~=1
            if isempty(Roots)==1
              Roots=0.6;
           else
            Roots=Roots(1,end);
           end
        end 
        t=sort(Roots);
        B0=(1-t).^3;
        B1=3.*t.*((1-t).^2);
        B2=3.*(t.^2).*(1-t);
        B3=t.^3;
        Ext=[Ext,(B0.*Bezier(:,1))+(B1.*Bezier(:,2))+(B2.*Bezier(:,3))+(B3.*Bezier(:,4))];
        if length(Beziers_Inside)==2 && j==2
           Roots(1,1)=Roots(1,1)+1;
        end
        Ext_tk=[Ext_tk,Roots];
     end
 
    Extremes_Tk_R_INV{1,i}=Ext_tk;
    Extremes_R_INV{1,i}=Ext;
    Interests_R_INV=[Interests_R_INV,CPs_R(:,1),Ext,CPs_R(:,end)];
end
for i=1:1:width(Extremes_R)
                        exts=Extremes_R{1,i};
                        exts_new=Extremes_R_INV{1,i};
                        exts(:,2)=exts_new(:,2);
                        Extremes_R{1,i}=exts;
                        %------
                        tks=Extremes_Tk_R{1,i};
                        tks_new=Extremes_Tk_R_INV{1,i};
                        tks(:,2)=tks_new(:,2);
                        Extremes_Tk_R{1,i}=tks;
                        %------
                        Interests_R(:,(4*i)-1) = Interests_R_INV (:,(4*i)-1);        
end
end
%===================================================================================

INFO_L.Extremes_Tk=Extremes_Tk_L;
INFO_R.Extremes_Tk=Extremes_Tk_R;
INFO_L.Extremes=Extremes_L;
INFO_R.Extremes=Extremes_R;
INFO_L.Interests=Interests_L;
INFO_R.Interests=Interests_R;
end