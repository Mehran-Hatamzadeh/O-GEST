function [IDs_L,IDs_R]=ID_Cycles_Up_Down_Events_Indexes(INFO_L,INFO_R)
Dim=2;
N_Cycle_L=INFO_L.N_Cycle;
N_Cycle_R=INFO_R.N_Cycle;
CPs_Cycles_Left_Ankle=INFO_L.CPs;
CPs_Cycles_Right_Ankle=INFO_R.CPs;
Ncp_L=INFO_L.Ncp;
Ncp_R=INFO_R.Ncp;
%-----------------------------------------
Indexes_Events_L=[];
Other_Bezier_ID_L=[];
Other_Bezier_tk_L=[];
for i=1:1:N_Cycle_L
    C1_L=CPs_Cycles_Left_Ankle{1,i};
    index=(i-1)*(Ncp_L*Dim);
    P0C1d_L=C1_L(2,1);
    PnC1d_L=C1_L(2,end);
    INDEX=[NaN,NaN];
    ID=["NO","NO"];
    Other_Bezier_ID=[NaN,NaN];
    Other_Bezier_tk=["NaN","NaN"];
    for j=1:1:N_Cycle_R
        Cj_R=CPs_Cycles_Right_Ankle{1,j};
        P0Cjd_R=Cj_R(2,1);
        PnCjd_R=Cj_R(2,end);
        if P0Cjd_R>=P0C1d_L && P0C1d_L>=PnCjd_R
           ID(1,1)="YES";
           INDEX(1,1)=index+1;
           Other_Bezier_ID(1,1)=j;
           Other_Bezier_tk(1,1)="Second";
        end
        if P0Cjd_R>=PnC1d_L && PnC1d_L>=PnCjd_R
           ID(1,2)="YES";
           INDEX(1,2)=index+(Ncp_L*Dim)-(Dim-1);
           Other_Bezier_ID(1,2)=j;
           Other_Bezier_tk(1,2)="First";
        end
    end
    ID_L{1,i}=ID;
    Indexes_Events_L=[Indexes_Events_L,INDEX];
    Other_Bezier_ID_L=[Other_Bezier_ID_L,Other_Bezier_ID];
    Other_Bezier_tk_L=[Other_Bezier_tk_L,Other_Bezier_tk];
end
IDs_L.ID=ID_L;
IDs_L.Indexes_Events=Indexes_Events_L;
IDs_L.Other_Bezier_ID=Other_Bezier_ID_L;
IDs_L.Other_Bezier_tk=Other_Bezier_tk_L;

%----------------------------------
Indexes_Events_R=[];
Other_Bezier_ID_R=[];
Other_Bezier_tk_R=[];
for i=1:1:N_Cycle_R
    C1_R=CPs_Cycles_Right_Ankle{1,i};
    index=(i-1)*(Ncp_R*Dim);
    P0C1d_R=C1_R(2,1);
    PnC1d_R=C1_R(2,end);
    INDEX=[NaN,NaN];
    ID=["NO","NO"];
    Other_Bezier_ID=[NaN,NaN];
    Other_Bezier_tk=["NaN","NaN"];
    for j=1:1:N_Cycle_L
        Cj_L=CPs_Cycles_Left_Ankle{1,j};
        P0Cjd_L=Cj_L(2,1);
        PnCjd_L=Cj_L(2,end);
        if P0Cjd_L>=P0C1d_R && P0C1d_R>=PnCjd_L
           ID(1,1)="YES";
           INDEX(1,1)=index+1;
           Other_Bezier_ID(1,1)=j;
           Other_Bezier_tk(1,1)="Second";
        end
        if P0Cjd_L>=PnC1d_R && PnC1d_R>=PnCjd_L
           ID(1,2)="YES";
           INDEX(1,2)=index+(Ncp_R*Dim)-(Dim-1);
           Other_Bezier_ID(1,2)=j;
           Other_Bezier_tk(1,2)="First";
        end
    end
    ID_R{1,i}=ID;
    Indexes_Events_R=[Indexes_Events_R,INDEX];
    Other_Bezier_ID_R=[Other_Bezier_ID_R,Other_Bezier_ID];
    Other_Bezier_tk_R=[Other_Bezier_tk_R,Other_Bezier_tk];
end
IDs_R.ID=ID_R;
IDs_R.Indexes_Events=Indexes_Events_R;
IDs_R.Other_Bezier_ID=Other_Bezier_ID_R;
IDs_R.Other_Bezier_tk=Other_Bezier_tk_R;
%----------------------------------
ids=[];
for i=1:1:N_Cycle_L
    I1=ID_L{1,i};
    ids=[ids,I1];
end
IDs_L.ids=ids;
counter=0;
for i=1:1:2*N_Cycle_L
    if ids(1,i)=="YES"
        break
    else
        counter=counter+1;
    end
end
IDs_L.interests_remove_begin=counter.*2;
counter=0;
for i=2*N_Cycle_L:-1:1
    if ids(1,i)=="YES"
        break
    else
        counter=counter+1;
    end
end
IDs_L.interests_remove_end=counter.*2;
%------------------------------------------------
ids=[];
for i=1:1:N_Cycle_R
    I1=ID_R{1,i};
    ids=[ids,I1];
end
IDs_R.ids=ids;
counter=0;
for i=1:1:2*N_Cycle_R
    if ids(1,i)=="YES"
        break
    else
        counter=counter+1;
    end
end
IDs_R.interests_remove_begin=counter.*2;
counter=0;
for i=2*N_Cycle_R:-1:1
    if ids(1,i)=="YES"
        break
    else
        counter=counter+1;
    end
end
IDs_R.interests_remove_end=counter.*2;    
    
end