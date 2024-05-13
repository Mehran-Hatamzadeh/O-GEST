function [Lb_L,Ub_L]=Bands_Lower_Upper(INFO)
Dim=2;
Ncp=INFO.Ncp;
Cycles_Data=INFO.Sections;
%--------------------------------
D=INFO.Data;
T=INFO.Time;
diff=zeros(height(D)-1,1);
for r=1:1:height(D)-1
    diff(r,1)=(D(r+1,1)-D(r,1))./(T(r+1,1)-T(r,1));
end
diff=abs(diff);
th_total=mean(diff)*0.15;
%-------------------------------- 
for i=1:1:length(Cycles_Data)
    data=Cycles_Data{1,i};
    %--------
    D=data(:,2);
    T=data(:,1);
    diff=zeros(height(D)-1,1);
    for r=1:1:height(D)-1
        diff(r,1)=(D(r+1,1)-D(r,1))./(T(r+1,1)-T(r,1));
    end
    diff=abs(diff);
    diff(diff<th_total)=0;
    [~,MaxPos]=max(diff);
    Start_diff=diff(1:MaxPos,1);
    End_diff=diff(MaxPos+1:end,1);
    Start_SUM=sum(double(ismember(Start_diff,0)));
    End_SUM=sum(double(ismember(End_diff,0)));
    Shorten_Start=floor(Start_SUM*(0.4));
    Shorten_End=floor(End_SUM*(0.4));
    if Shorten_Start==0
       Shorten_Start=1;
    end
    if Shorten_End==0
       Shorten_End=1;
    end
    T_shorten_Start=T(Shorten_Start,1)-T(1,1);
    T_shorten_End=T(Shorten_End,1)-T(1,1);
    %--------
    TStart=data(1,1);
    TEnd=data(end,1);
    DVar=max(data(:,2))-min(data(:,2));
    DUpLim=max(data(:,2))+(0.15*DVar);
    DDownLim=min(data(:,2))-(0.15*DVar);
    %--------
    TStart=TStart+T_shorten_Start; 
    TEnd=TEnd-(T_shorten_End*1);
    %--------
    if Ncp==4 && Dim==2
       lb=[TStart,DDownLim,TStart,DDownLim,TStart,DDownLim,TStart,DDownLim] ;
       ub=[TEnd,DUpLim,TEnd,DUpLim,TEnd,DUpLim,TEnd,DUpLim];
    elseif Ncp==5 && Dim==2
       lb=[TStart,DDownLim,TStart,DDownLim,TStart,DDownLim-(DVar*0.8),TStart,DDownLim,TStart,DDownLim] ;
       ub=[TEnd,DUpLim,TEnd,DUpLim,TEnd,DUpLim,TEnd,DUpLim,TEnd,DUpLim]; 
    end
    Lb_L(1,((i-1)*Ncp*Dim)+1:i*Ncp*Dim)=lb;
    Ub_L(1,((i-1)*Ncp*Dim)+1:i*Ncp*Dim)=ub;
end

end