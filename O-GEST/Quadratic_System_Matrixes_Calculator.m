function [H_Final,F_Final,E_Total]=Quadratic_System_Matrixes_Calculator (INFO)
% ========================================================================
% Description: This function computes H and F matrixes required to solve
%              a quadratic system
% ========================================================================
Dim=2;
Basis=INFO.Basis;
CPs_Cycles=INFO.CPs;
Cycles_Data=INFO.Sections;
Ncp=INFO.Ncp;
%-----
N_Cycle=length(Cycles_Data);
H_Final=zeros(N_Cycle*Dim*Ncp,Dim*Ncp*N_Cycle);
F_Final=zeros(N_Cycle*Dim*Ncp,1);
Identity_Line=zeros(Dim,Dim);
Identity_Line(2,2)=1;
E_Total=0;

for i=1:1:N_Cycle
    Controls=CPs_Cycles{1,i}; 
    raw_data=Cycles_Data{1,i};
    Data=[raw_data(:,1),raw_data(:,2)]';
    Data_Line1=Data(:,Data(1,:)<Controls(1,1));
    Data_Line2=Data(:,Data(1,:)>Controls(1,end));
    Data_Bspline=Data;
    Data_Bspline(:,1:1:width(Data_Line1))=[];
    Data_Bspline(:,end-width(Data_Line2)+1:1:end)=[];
    F=zeros(Dim*Ncp,1);
    H=zeros(Dim*Ncp,Dim*Ncp); 
    %-------------------------Line1----------------------
    F(2,1) = F(2,1) + sum(-2.*Data_Line1(2,:));
    H(1:Dim,1:Dim) = H(1:Dim,1:Dim) + ((2*Identity_Line).*width(Data_Line1));
    %-------------------------Line2----------------------
    F(end-Dim+2,1) = F(end-Dim+2,1) + sum(-2.*Data_Line2(2,:));
    H(end-Dim+1:end,end-Dim+1:end) = H(end-Dim+1:end,end-Dim+1:end) + ((2*Identity_Line).*width(Data_Line2));
    %------------------------BSpline---------------------
    [Tk,~,E_Bspline] = Find_Projection_On_Cubic_Bspline (Controls,Data_Bspline);
    %----Error Value Calculation-----
    E_Line1=abs(Data_Line1(2,:)-Controls(2,1));
    E_Line2=abs(Data_Line2(2,:)-Controls(2,end)); 
    E_Total=E_Total+sum(E_Line1)+sum(E_Bspline)+sum(E_Line2);
    %--------------------------------
    Ni_Matrix=zeros(length(Tk),Ncp);
    f=zeros(Dim.*Ncp,1);
    for B=1:1:Ncp
        Ni_Matrix(:,B)=fnval(Basis(1,B),Tk)';
        Multiplied=Ni_Matrix(:,B)'.*Data_Bspline;
        f((2*B)-1:2*B,1)=-2.*sum(Multiplied,2);
    end
    F=F+f;
    for j=1:1:height(Ni_Matrix)
        Ni=Ni_Matrix(j,:);
        mm=reshape(2*(Ni'*Ni),[1,Ncp*Ncp]);
        M=reshape([mm; zeros(size(mm))], 1, []);
        MS=reshape(M,[Dim.*Ncp,Ncp])';
        h=zeros(Dim.*Ncp,Dim.*Ncp);
        h(1:2:(Dim*Ncp),:)=MS;
        MS2=[zeros(height(MS),1),MS(:,1:end-1)];
        h(2:2:(Dim*Ncp),:)=MS2;
        H=H+h;
    end   
End=Ncp*Dim*i;
H_Final(End-(Ncp*Dim-1):End,End-(Ncp*Dim-1):End)=H;
F_Final(End-(Ncp*Dim-1):End,1)=F;
end
end