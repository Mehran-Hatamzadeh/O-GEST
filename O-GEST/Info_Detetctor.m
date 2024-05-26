function [INFO_L,INFO_R] = Info_Detetctor (JointsDepth_L,JointsDepth_R,Time)
% ========================================================================
% Description: This function seperates data into sections. To do so, it 
%              first smooths the data using a low pass filter and finds 
%              the intersection points that should be used for sectioning.
%              after finding the intesection points, its sections the original
%              data (not the smoohthed ones).
%              Two methods used for intersections finding: First method depends on intersection 
%              between left and right horizontal trajectories. If it fails, the second
%              method applies a threshold on first derivative of the trajectory to find
%              the intersection points which are then used to section original data.
% ========================================================================
% Developer:Mehran Hatamzadeh
%           Universite Cote d'Azur, LAMHESS, INRIA
% -------------------------------------------------------------------------
INFO_L=[];
INFO_R=[];
StartEnd_Frames=[1,mean([height(JointsDepth_L),height(JointsDepth_R)])-1];

JD_L=JointsDepth_L(:,1); 
JD_R=JointsDepth_R(:,1);

JD_L(StartEnd_Frames(1,1):StartEnd_Frames(1,2),2)=sgolayfilt(JD_L(StartEnd_Frames(1,1):StartEnd_Frames(1,2),1),2,15);
JD_R(StartEnd_Frames(1,1):StartEnd_Frames(1,2),2)=sgolayfilt(JD_R(StartEnd_Frames(1,1):StartEnd_Frames(1,2),1),2,15);


Subtrac=sgolayfilt(JD_L(:,2),2,21)-sgolayfilt(JD_R(:,2),2,21);

Sub = abs(sgolayfilt(Subtrac,2,21));

TF = islocalmin(Sub);

TF_Double=double(TF);
TF_Double(:,2)=1:1:height(TF);
TF_Double=TF_Double';
TF_Double(:,TF_Double(1,:)==0)=[];
Intersections=TF_Double(2,:);
%---------------------------------------------
Diff_LR=zeros(1,width(Intersections));
for i=1:1:length(Intersections)
    Diff_LR(1,i)=JD_L(Intersections(1,i),2)-JD_R(Intersections(1,i),2);
end
Threshold=max(abs(JD_L(:,2)-JD_R(:,2))).*0.1;
DIFF_LR=[];
DIFF_LR(1,:)=1:1:width(Diff_LR);
DIFF_LR(2,:)=abs(Diff_LR);
DIFF_LR(:,DIFF_LR(2,:)<Threshold)=[];
Intersections(:,DIFF_LR(1,:))=[];
%------------------------------------------
%check if difference from peak in between is bigger than the threshold 
IDs=zeros(1,length(Intersections)-1);
for i=1:1:length(Intersections)-1
    Diff=max(Sub(Intersections(1,i):Intersections(1,i+1)))-min(Sub(Intersections(1,i):Intersections(1,i+1)));
    if Diff>(Threshold)*0.75
        IDs(1,i)=1;
    else
        IDs(1,i)=0;
    end
end 
Intersections(:,IDs(1,:)==0)=[];
%------------------------------------------
Intersections(:,Intersections<StartEnd_Frames(1,1) | Intersections>StartEnd_Frames(1,2))=[];
%=====================================================================
%---check if Intersections are correct---
D=JD_L(:,1);
T=Time;
diff=zeros(height(D)-1,1);
for r=1:1:height(D)-1
    diff(r,1)=(D(r+1,1)-D(r,1))./(T(r+1,1)-T(r,1));
end
diff=abs(diff);
th_total=mean(diff)*0.2;
diff(diff<th_total)=0;
diff(diff<(max(diff)*0.2))=0;

Zoj=2:2:width(Intersections);
Fard=1:2:width(Intersections);
INTS_Zoj=Intersections(1,Zoj);
INTS_Fard=Intersections(1,Fard);
Intersections_InfoL="InCorrect";
if sum(diff(INTS_Zoj,1))==0 &&  sum(diff(INTS_Fard,1))~=0
   Intersections_InfoL="Correct";
end
if sum(diff(INTS_Zoj,1))~=0 &&  sum(diff(INTS_Fard,1))==0
   Intersections_InfoL="Correct";
end

D=JD_R(:,1);
T=Time;
diff=zeros(height(D)-1,1);
for r=1:1:height(D)-1
    diff(r,1)=(D(r+1,1)-D(r,1))./(T(r+1,1)-T(r,1));
end
diff=abs(diff);
th_total=mean(diff)*0.2;
diff(diff<th_total)=0;
diff(diff<(max(diff)*0.2))=0;

Zoj=2:2:width(Intersections);
Fard=1:2:width(Intersections);
INTS_Zoj=Intersections(1,Zoj);
INTS_Fard=Intersections(1,Fard);
Intersections_InfoR="InCorrect";
if sum(diff(INTS_Zoj,1))==0 &&  sum(diff(INTS_Fard,1))~=0
   Intersections_InfoR="Correct";
end
if sum(diff(INTS_Zoj,1))~=0 &&  sum(diff(INTS_Fard,1))==0
   Intersections_InfoR="Correct";
end

Intersections_Info="InCorrect";
if Intersections_InfoR=="Correct" && Intersections_InfoL=="Correct" 
    Intersections_Info="Correct";
end


if Intersections_Info=="InCorrect"
    
    D=JD_L(:,1);
    T=Time;
    diff=zeros(height(D)-1,1);
    for r=1:1:height(D)-1
        diff(r,1)=(D(r+1,1)-D(r,1))./(T(r+1,1)-T(r,1));
    end
    diff=abs(diff);
    th_total=mean(diff)*0.2;
    diff(diff<th_total)=0;
    diff(diff<(max(diff)*0.2))=0;
    LocMax=double(islocalmin(-diff));
    LocMax=LocMax';
    LocMax(2,:)=1:1:width(LocMax);
    LocMax(:,LocMax(1,:)==0)=[];
    LocMax=LocMax(2,:);
    LocMin=double(islocalmin(diff));
    LocMin=LocMin';
    LocMin(2,:)=1:1:width(LocMin);
    LocMin(:,LocMin(1,:)==0)=[];
    LocMin=LocMin(2,:);
    Sorted_L= sort([LocMax,LocMin]);
    
   
    D=JD_R(:,1);
    T=Time;
    diff=zeros(height(D)-1,1);
    for r=1:1:height(D)-1
        diff(r,1)=(D(r+1,1)-D(r,1))./(T(r+1,1)-T(r,1));
    end
    diff=abs(diff);
    th_total=mean(diff)*0.2;
    diff(diff<th_total)=0;
    diff(diff<(max(diff)*0.2))=0;
    LocMax=double(islocalmin(-diff));
    LocMax=LocMax';
    LocMax(2,:)=1:1:width(LocMax);
    LocMax(:,LocMax(1,:)==0)=[];
    LocMax=LocMax(2,:);
    LocMin=double(islocalmin(diff));
    LocMin=LocMin';
    LocMin(2,:)=1:1:width(LocMin);
    LocMin(:,LocMin(1,:)==0)=[];
    LocMin=LocMin(2,:);
    Sorted_R= sort([LocMax,LocMin]);

    if width(Sorted_L)>=width(Sorted_R)
       Intersections=Sorted_L;
    else
       Intersections=Sorted_R;
    end
    Intersections_Info="Corrected_With_Thresholds";
end
%=====================================================================
MidPointStart=round((Intersections(1,1)+Intersections(1,2))/2);

if JD_L(MidPointStart,2)>JD_R(MidPointStart,2) 
    %start with left flatfoot 
    Start='Left';
    id_L=1:2:length(Intersections);
    N_Cycle_L=length(id_L)-1;
    L_info=[Intersections(1,1),Intersections(1,id_L(1,end))];
    L_Ints=Intersections(1,id_L);
    id_R=2:2:length(Intersections);
    N_Cycle_R=length(id_R)-1;
    R_info=[Intersections(1,2),Intersections(1,id_R(1,end))];
    R_Ints=Intersections(1,id_R);
elseif JD_L(MidPointStart,2)<JD_R(MidPointStart,2) 
       %start with right flatfoot 
       Start='Right';
       id_R=1:2:length(Intersections);
       N_Cycle_R=length(id_R)-1;
       R_info=[Intersections(1,1),Intersections(1,id_R(1,end))];
       R_Ints=Intersections(1,id_R);
       id_L=2:2:length(Intersections);
       N_Cycle_L=length(id_L)-1;
       L_info=[Intersections(1,2),Intersections(1,id_L(1,end))];
       L_Ints=Intersections(1,id_L);
end



if R_info(1,1)<StartEnd_Frames(1,1)
   R_info(1,1)= StartEnd_Frames(1,1);
end
if L_info(1,1)<StartEnd_Frames(1,1)
   L_info(1,1)= StartEnd_Frames(1,1);
end
if R_info(1,2)>StartEnd_Frames(1,2)
   R_info(1,2)= StartEnd_Frames(1,2);
end
if L_info(1,2)>StartEnd_Frames(1,2)
   L_info(1,2)= StartEnd_Frames(1,2);
end

Diff_L=zeros(1,length(L_Ints)-1);
for i=1:1:length(L_Ints)-1
    Diff_L(1,i)=L_Ints(1,i+1)-L_Ints(1,i);
end
if width(Diff_L)>1
if max(Diff_L)==Diff_L(1,1) && round(round(max(Diff_L(1,2:end))).*1.2) < Diff_L(1,1)
  L_info(1,1)=L_info(1,1) + round( (Diff_L(1,1)-max(Diff_L(1,2:end))).*0.8);
end
if max(Diff_L)==Diff_L(1,end) && round(round(max(Diff_L(1,1:end-1))).*1.2) < Diff_L(1,end)
  L_info(1,2)=L_info(1,2) - round( (Diff_L(1,end)-max(Diff_L(1,1:end-1))).*0.8);
end
end

Diff_R=zeros(1,length(R_Ints)-1);
for i=1:1:length(R_Ints)-1
    Diff_R(1,i)=R_Ints(1,i+1)-R_Ints(1,i);
end
if width(Diff_R)>1
if max(Diff_R)==Diff_R(1,1) && round(round(max(Diff_R(1,2:end))).*1.2) < Diff_R(1,1)
  R_info(1,1)=R_info(1,1) + round( (Diff_R(1,1)-max(Diff_R(1,2:end))).*0.8);
end
if max(Diff_R)==Diff_R(1,end) && round(round(max(Diff_R(1,1:end-1))).*1.2) < Diff_R(1,end)
  R_info(1,2)=R_info(1,2) - round( (Diff_R(1,end)-max(Diff_R(1,1:end-1))).*0.8);
end
end

INFO_L.N_Cycle=N_Cycle_L;
INFO_L.SEsamples=L_info;
INFO_L.Time=Time(L_info(1,1):L_info(1,2),1);
INFO_L.Data=JointsDepth_L(L_info(1,1):L_info(1,2),:);
INFO_L.Intersections_Info=Intersections_Info;

INFO_R.N_Cycle=N_Cycle_R;
INFO_R.SEsamples=R_info;
INFO_R.Time=Time(R_info(1,1):R_info(1,2),1);
INFO_R.Data=JointsDepth_R(R_info(1,1):R_info(1,2),:);
INFO_R.Intersections_Info=Intersections_Info;
%-------------------------------------------------------
if Start=="Left"
   idsL=1:2:width(Intersections);
   idsR=2:2:width(Intersections);
elseif Start=="Right"
   idsR=1:2:width(Intersections);
   idsL=2:2:width(Intersections);
end

Sections=cell(1,N_Cycle_L);
for i=1:1:N_Cycle_L
    t=Time(Intersections(1,idsL(1,i)):Intersections(1,idsL(1,i+1)) , 1);
    d=JointsDepth_L(Intersections(1,idsL(1,i)):Intersections(1,idsL(1,i+1)) , :);
    Sections{1,i}=[t,d];
end
INFO_L.Sections=Sections;
%-----
Sections=cell(1,N_Cycle_R);
for i=1:1:N_Cycle_R
    t=Time(Intersections(1,idsR(1,i)):Intersections(1,idsR(1,i+1)) , 1);
    d=JointsDepth_R(Intersections(1,idsR(1,i)):Intersections(1,idsR(1,i+1)) , :);
    Sections{1,i}=[t,d];
end
INFO_R.Sections=Sections;

end