function [mean_value] = fetch_tile_values(tile_array,value)

P = load('~/PACTS/MR/MAT/tileValue.mat');

stepsize = (P.TA_rows - rem(P.TA_rows,P.tRC))/P.tRC - P.hpad;

seP = rem(P.TA_rows,P.tRC)/2;

startR = seP+P.hpad/2+1;
endR = stepsize+startR -1 ;

IstartR = seP+P.hpad/2+1;
IendR = stepsize+startR -1 ;

IstartC=startR;
IendC= endR;

startC=startR;
endC= endR;
temp = 0;

if value == 1
    for col = 1:P.tRC
      for row = 1:P.tRC
           temp = temp+tile_array(startR,startC);
           startR = endR+P.hpad+1;
           endR = startR+stepsize -1 ;
       end
        mean_value(col) = temp/P.tRC;
        temp=0;
        %mean_value(i)=temp_value/7;
        startC = endC+P.hpad+1;
        endC = startC+stepsize-1;
        startR = IstartC;
        endR = IendC;
    end
elseif value == 2
    for row = 1:P.tRC
      for col = 1:P.tRC
           tile_array(startR,startC)
           temp = temp+tile_array(startR+5,startC+5);
           startC = endC+P.hpad+1;
           endC = startC+stepsize -1 ;
       end
        mean_value(row) = temp/P.tRC;
        temp=0;
        %mean_value(i)=temp_value/7;
        startR = endR+P.hpad+1;
        endR = startR+stepsize-1;
        startC = IstartC;
        endC = IendC;
    end
end

end