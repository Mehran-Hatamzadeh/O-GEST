function [INFO]=Trend_INFO_Corrector(info,Setting)

INFO=info;
INFO.N_Gait_Cycles=(info.N_Cycle)-1;
INFO.N_Sections=info.N_Cycle;
INFO.StartEndsamples=info.SEsamples;
INFO.Time=info.Time;
INFO.Data=info.Data;
if Setting.Direction=="Upward"
    INFO.Data=-info.Data;
end  
INFO.Sections=info.Sections;
if Setting.Direction=="Upward"
    for I=1:1:width(info.Sections)
        Sec=info.Sections{1,I};
        INFO.Sections{1,I}=[Sec(:,1),-Sec(:,2)];
    end    
end  
INFO.Ncp=info.Ncp;
INFO.Basis=info.Basis;
INFO.Knots=info.Knots;
INFO.CPs=info.CPs;
if Setting.Direction=="Upward"
    for I=1:1:width(info.CPs)
        cps=info.CPs{1,I};
        INFO.CPs{1,I}=[cps(1,:);-cps(2,:)];
    end
end  
INFO.N_Param=info.N_Param;
INFO.Intersections=info.Intersections;
if Setting.Direction=="Upward"
   INFO.Intersections=[info.Intersections(1,:);-info.Intersections(2,:)];
end
INFO.Extremes_Tk=info.Extremes_Tk;
INFO.Extremes=info.Extremes;
if Setting.Direction=="Upward"
    for I=1:1:width(info.Extremes)
        EXT=info.Extremes{1,I};
        INFO.Extremes{1,I}=[EXT(1,:);-EXT(2,:)];
    end
end  
INFO.Interests=info.Interests;
if Setting.Direction=="Upward"
   INFO.Interests(2,:)=-info.Interests(2,:);
end
INFO.Direction=Setting.Direction;
INFO.Type=Setting.Type;
INFO=rmfield(INFO,'SEsamples');
INFO=rmfield(INFO,'N_Cycle');
end