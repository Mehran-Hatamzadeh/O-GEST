function [JointsDepth_L,JointsDepth_R,Time]=Data_Checker(JointsDepth_L,JointsDepth_R,Time)
% ========================================================================
% Description: This function checks the data to eliminate existing gaps, 
%              and NaN values. It provides warnings in case any abnormality
%              is detected and whether it was able to resolve them or not.             
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
JDL=[JointsDepth_L,JointsDepth_R];
%------------------------------------------
ID_Begining=zeros(1,width(JDL));
for i=1:1:width(JDL)
    for j=1:1:height(JDL)
        if JDL(j,i)==0 || isnan(JDL(j,i))
            ID_Begining(1,i)=j;
        else
            break;
        end
    end
end
%------------------------------------------
ID_Ending=zeros(1,width(JDL));
for i=1:1:width(JDL)
    for j=height(JDL):-1:1
        if JDL(j,i)==0 || isnan(JDL(j,i))
            ID_Ending(1,i)=height(JDL)-j+1;
        else
            break;
        end
    end
end
%------------------------------------------
for i=1:1:width(JDL)
    jdl= JDL(ID_Begining(1,i)+1:height(JDL)-ID_Ending(1,i),i);
    jdl=jdl';
    jdl(2,:)=ID_Begining(1,i)+1:1:height(JDL)-ID_Ending(1,i);
    gaps=jdl(:,jdl(1,:)==0 | isnan(jdl(1,:)));
    gaps(2,:)=gaps(2,:);
    if isempty(gaps)~=1
        cprintf([1,0.5,0],   'Gait GEST Warning: Input depth trajectories contains gaps...\n'); 
        if width(gaps)>1
        DIF=diff(gaps(2,:));
        GAPS=[1:1:width(DIF);DIF];
        GAPS(:,GAPS(2,:)==1)=[];
        BCH=zeros(1,width(GAPS)*2);
        for j=1:1:width(GAPS)
            BCH(1,(2*j)-1:(2*j))=[gaps(2,GAPS(1,j))+1,gaps(2,GAPS(1,j)+1)-1];
        end
        batch=[gaps(2,1)-1,BCH,gaps(2,end)+1];
        end
        if width(gaps)==1
           batch=[gaps(2,1)-1 ,gaps(2,1)+1];
        end
        batch=batch-ID_Begining(1,i);
        for k=1:1:(width(batch)/2)
            M1=batch(1,(2*k)-1); 
            M2=batch(1,(2*k)) ;
            jdl(1,M1:M2)=linspace(jdl(1,M1),jdl(1,M2),M2-M1+1);
        end
        JDL(ID_Begining(1,i)+1:height(JDL)-ID_Ending(1,i),i)=jdl(1,:)';
    end
end

%------------------------------------------
if sum(ID_Begining)~=0
   cprintf([1,0.5,0],   'Gait GEST Warning: Input depth trajectories contain NaN or Zero values at the begining...\n');  
   JDL(1:max(ID_Begining),:)=[];
   Time(1:max(ID_Begining),:)=[];
end
if sum(ID_Ending)~=0
   cprintf([1,0.5,0],   'Gait GEST Warning: Input depth trajectories contain NaN or Zero values at the end...\n');  
   JDL(end-max(ID_Ending)+1 : end,:)=[];
   Time(end-max(ID_Ending)+1 : end,:)=[];
end
%------------------------------------------
JointsDepth_L=JDL(:,1:(width(JDL)/2));
JointsDepth_R=JDL(:,(width(JDL)/2)+1 : end);
%------------------------------------------
INDIC=zeros(1,width(JointsDepth_L));
Frist_Peak=zeros(1,width(JointsDepth_L));
for i=1:1:width(JointsDepth_L)
    SUB=abs(JointsDepth_L(:,i)-JointsDepth_R(:,i));    
    D=double(islocalmin(-SUB))';
    D(2,:)=1:1:width(D);
    D(:,D(1,:)==0)=[];
    Frist_Peak(1,i)=D(2,1);
    if min(SUB(1:D(2,1),1))==SUB(1,1) && SUB(1,1)<mean(SUB)*0.1
       INDIC(1,i)=1; 
    end
end
if sum(INDIC)~=0
   cprintf([1,0.5,0],   'start shortened\n');
   TH=floor(mean(Frist_Peak)/10)+1;
   JointsDepth_L(1:TH,:)=[];
   JointsDepth_R(1:TH,:)=[];
   Time(1:TH,:)=[];
end

INDIC=zeros(1,width(JointsDepth_L));
Last_Peak=zeros(1,width(JointsDepth_L));
for i=1:1:width(JointsDepth_L)
    SUB=abs(JointsDepth_L(:,i)-JointsDepth_R(:,i));    
    D=double(islocalmin(-SUB))';
    D(2,:)=1:1:width(D);
    D(:,D(1,:)==0)=[];
    Last_Peak(1,i)=D(2,end);
    if min(SUB(D(2,end):end,1))==SUB(end,1) && SUB(end,1)<mean(SUB)*0.1
       INDIC(1,i)=1; 
    end
end
if sum(INDIC)~=0
    cprintf([1,0.5,0],   'end shortened\n');
   TH=floor(mean(height(JointsDepth_L)-Last_Peak)/3)+1;
   JointsDepth_L(end-TH+1:end,:)=[];
   JointsDepth_R(end-TH+1:end,:)=[];
   Time(end-TH+1:end,:)=[];
end

end