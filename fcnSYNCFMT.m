function [ SYNCFMT ] = fcnSYNCFMT( FMT, plotDatenumArray )
%FCNSYNCFMT Summary of this function goes here
%   Detailed explanation goes here



fn = fieldnames(FMT);

SYNCFMT.Seen = FMT.Seen;
SYNCFMT.PARM = FMT.PARM;

for n = 1:length(fn)
    try
        fn2 = fieldnames(FMT.(fn{n}));
        for j = 1:length(fn2)
            if isempty(strfind(fn2{j},'Time')) == 1
                SYNCFMT.(fn{n}).(fn2{j}) = interp1(FMT.(fn{n}).TimeLOCAL,FMT.(fn{n}).(fn2{j}),plotDatenumArray,'previous');
            end
        end
    end
end

end

