function [cbf,delay,cbv,rt]=SVD_easy_gagan(conc_vector,AIFin,OIset,delt,smoothaif)


if isempty(conc_vector)
    cbf = [];
    delay = [];
    return;
end


AIF=double(AIFin);
npoints=size(conc_vector, 1);


%zero pad
vlength=length(AIF);
%piclogic=sum(cmap.^2,3)>0;    %only bother with values that change



AIF=[AIF zeros(1,vlength+1)]; %zeropadding af AIF

AIFmatrix=aifm1_sim(AIF,delt,smoothaif);         %this creates the circular matrix

[U,S,V]=svd(AIFmatrix);

invS = zeros(size(S));

for nn=1:length(S)
    invS(nn,nn)=1/S(nn,nn);             %invert diagonal
end



%make a truncated SVD table of V*(mymat.*invS)*U'

%first page is all ones= no truncation, then increasing truncation w/ pages
mylength=size(invS,1);

invAIFtable=zeros(mylength,mylength,mylength);
inv_calc = false(size(invS,1));

for n=1:size(invS,1)
    nzeros=n-1;               %start off with no zeros end with all but one
    nones=size(invS,1)-nzeros;     %all ones to start out, at the end just the UL corner
    myvec=[ones(1,nones) zeros(1,nzeros)];
    mymat=diag(myvec);
    invAIFtable(:,:,n)=V*(mymat.*invS)*U';    %lookup table from notrunk (all ones) to maxtrunc
end

%so pagenumber is number of zeros-1

concmat = zeros(npoints,2*vlength+1); %zeropadding af..
concmat(:,1:vlength)=conc_vector;   %


if isfloat(concmat)
    concmat=double(concmat);
end

cbf  = zeros(npoints, 1);
delay=zeros(npoints, 1);
cbv=zeros(npoints, 1);

%impresp=zeros(size(npoints,2*vlength+1));


%check this later:
rt=zeros(size(concmat,1),size(concmat,2));


for k=1:size(concmat,1)
    r=myiterate(concmat(k,:)',OIset); %finds the optimum threshold
    [cbf(k),delay(k)]=max(r);
    cbv(k)=delt*sum(r);           %should be reimplementation of trapz, but should not be a big deal
    rt(k,:)=r;
end


wrap=delay>vlength;
nowrap=delay<=vlength;

delay(wrap)=-delt*(2*vlength+1-delay(wrap)+1);
delay(nowrap)=(delay(nowrap)-1)*delt;



















%%%UTILITIES BEWARE OF THE GLOBAL SCOPE OF ALL OF THE ABOVE!!



    function calc_invAIF(n)
        nzeros=n-1;               %start off with no zeros end with all but one
        nones=size(invS,1)-nzeros;     %all ones to start out, at the end just the UL corner
        myvec=[ones(1,nones) zeros(1,nzeros)];
        mymat=diag(myvec);
        invAIFtable(:,:,n)=V*(mymat.*invS)*U';    %lookup table from notrunk (all ones) to maxtrunc
        inv_calc(n) = true;
    end


    function cOI=getO(r)
        fmax=max(r);
        L=length(r);
        coeff=[1 -2 1];
        co = conv(r, coeff);
        mysum = sum(abs(co(3:end-2)));
        %{
    mysum=0;

    for n=2:L-1
        mysum=mysum+abs(sum(coeff'.*r((n-1):(n+1))));
    end
        %}
        cOI=(1/(L*fmax))*mysum;
    end



    function r=myiterate(cvector,OIset)
        
        ndims=size(invAIFtable,3);
        maxpos=ndims;
        minpos=1;
        currentpos=round(ndims/2);
        found=false;
        while ~(found)
            if ~inv_calc(currentpos)
                calc_invAIF(currentpos);
            end
            r=invAIFtable(:,:,currentpos)*cvector; %page has currentpos-1 zeroes
            OI=getO(r);
            
            if OI>OIset  %bigger than supposed to be
                minpos=currentpos;            %the currentpos is new minimum
            else
                maxpos=currentpos;            %the currentpos is new maximum
            end
            
            
            if (maxpos-minpos)==1;            %did they narrow in?
                %we could get here in two ways, the lates currentpoint was just set to min pos
                %that means that it oscilated too much and that the oi
                %criterion is within min and max (max complies)
                %The other way round minpos does not comply maxpos (last
                %set does
                if ~inv_calc(maxpos)
                    calc_invAIF(maxpos);
                end
                
                r=invAIFtable(:,:,maxpos)*cvector;
                found=true;
            end
            
            currentpos=round((maxpos-minpos)/2)+minpos;   %set the new currentpoint to �way btw mean and max
        end
    end
end