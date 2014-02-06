function A=aifm_sim(aif,delt,dosmooth)

%function A=aifm(aif), aif must be starting at index 1 of aif - no delay allowed;
%returns AIF matrix for deconvolution  
aif=reshape(aif,[1 length(aif)]);



if dosmooth
    AIF=[0 aif 0];        %zero pad (for running w-average)
    lengthA=length(AIF);
    A=zeros(lengthA-2);
    %see theory chapter for filtering formula
    for row=1:lengthA-2;
        for column=1:lengthA-2;    
            if (row>=column);
                intoarraypos=row-column+1+1;              %as first entry of AIF will be a zeropadding and index starts at 1 not 0
                A(row,column)=delt*(AIF(intoarraypos-1)+4*AIF(intoarraypos)+AIF(intoarraypos+1))/6;
            end
        end
    end
else
    AIF=aif;
    lengthA=length(AIF);
    A=zeros(lengthA);
    for row=1:lengthA;
        for column=1:lengthA;    
            if (row>=column);
                intoarraypos=row-column+1;              %as first entry of AIF will be a zeropadding and index starts at 1 not 0
                A(row,column)=delt*AIF(intoarraypos);
            end
        end
    end
end
    


            
    
