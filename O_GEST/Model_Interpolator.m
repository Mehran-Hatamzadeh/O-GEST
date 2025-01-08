function Section_Smoothed=Model_Interpolator(CPs,Section,Knots)

Before=Section(:,Section(1,:)<=CPs(1,1));
After=Section(:,Section(1,:)>=CPs(1,end));
Spline_Area=Section(:,Section(1,:)>CPs(1,1) & Section(1,:)<CPs(1,end));
Before(2,:)=CPs(2,1);
After(2,:)=CPs(2,end);
if width(CPs)==4
    RANGE=1;
else
    RANGE=2;
end
SP=spmak(Knots,CPs);
interval=linspace(0,RANGE,10000);
INTERP=fnval(SP,interval);
Spline_Area_Smooth=zeros(2,width(Spline_Area));
for i=1:1:width(Spline_Area)
    [~,pos]=min(abs(INTERP(1,:)-Spline_Area(1,i)));
    Spline_Area_Smooth(:,i)=INTERP(:,pos);
end
Section_Smoothed=[Before,Spline_Area_Smooth,After];

end

