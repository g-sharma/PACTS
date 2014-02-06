function TA = cal_sliceTA(sampT,nSlices,timePoints,arSP)
    samp_step = sampT / nSlices;
    TA = zeros(timePoints,nSlices);
    for i = 1:timePoints
        for j = 1:2:nSlices
             TA(i,j)=arSP
             arSP = arSP + samp_step;
        end
        for j = 2:2:nSlices
            TA(i,j)=arSP
            arSP = arSP + samp_step;
        end
       
    end
    
end