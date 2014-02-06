
%% # Testgui Report oSVD (MTT,TMax) maps
load /home/gsharma/Programming/Matlab/Mypaper/results.mat;
load /home/gsharma/Programming/Matlab/Mypaper/gold_standard_maps.mat;
delay =2:2:14;


if oSVD_mtt ~= -1
    
    g_val=[25.5852   13.7004    9.5599    7.4714    6.2486    5.4473    4.8682];
    o_val = oSVD.mtt_tileValues_slice_one;
    g_array = results.omttmap; 
    o_array = pha_oSVD_mtt;
    
    differece = roundn((o_val - g_val),-1);
    if range(differece) == 0
        if differece(1) == 0
            flag.oSVD.mtt = 1;
        else
            flag.oSVD.mtt = 2;
        end
    else
        flag.oSVD.mtt = 3;
    end

    
    label_name='MTT';
    report_message=['Created on:' datestr(clock)];
    disp(report_message);
   
    %% # a) Gold Standard MTT Map                               b) Observed MTT Map                                   c) Difference MTT Map(Gold - Observed)"
   
    figure
    imagesc(g_array(:,:,1));
    colormap jet
    colorbar;
    
   
    map_heading_one =['a) Gold Standard ' label_name];
    title(map_heading_one);

    figure
    
    % make sure you fix this problem of unit and double. Why. where I am
    % wrong. As per soren I should be wrong.
    imagesc(g_array(:,:,1));
    colormap jet
    colorbar;
    map_heading_two =['b) Observed ' label_name];
    title(map_heading_two);

    figure;
    imagesc(g_array(:,:,1) - o_array(:,:,1));
    title('c) Difference Image');
    colormap jet
    colorbar;
    
    %% # Average MTT vs Delay
    
      
    
    figure;
    gh=plot(delay,o_val,'-*b','MarkerSize',5,'LineWidth',2.5);
    grid on;
    hold;
    oh=plot(delay,g_val,'-*r','MarkerSize',5,'LineWidth',1);
    
    head=[ 'oSVD mean ' label_name];
    title(head);
    xlabel('Delay Value(seconds)')
    head_one= ['Average ' label_name ' per delay(seconds)'];
    ylabel(head_one)
    
    legend('Location','north')
    head_two = ['Gold Standard ' label_name];
    set(gh,'DisplayName',head_two);
   
    head_three = ['Observed ' label_name];
    set(oh,'DisplayName',head_three);
    
    %% # MTT Map Comments

    if flag.oSVD.mtt == 1
        disp('Observed MTT perfusion Maps in line with gold Standard oSVD Implementation');
    elseif flag.oSVD.mtt == 2
        disp('Observed MTT perfusion Maps lag with a constant value from gold Standard oSVD Implementation');
    else
        disp('Observed MTT perfusion Maps does not inline with gold Standard oSVD Implementation');
    end    


end


    

if oSVD_tmax ~= -1
    g_val=[ 3.6000    5.4000    7.2000    9.0000   10.8000   12.8571   14.9143];
    o_val = oSVD.tmax_tileValues_slice_one;
    g_array = results.sdelaymap; 
    o_array = pha_oSVD_tmax;
    differece = roundn((o_val - g_val),-1);
    if range(differece) == 0
        if differece(1) == 0
            flag.oSVD.tmax = 1;
        else
            flag.oSVD.tmax = 2;
        end
    else
        flag.oSVD.tmax = 3;
    end
    
    
    label_name='TMax';
    %report_message=['Created on:' datestr(clock) '  for ' label_name  ' MAPS'];
    %disp(report_message);
   
    %% # a) Gold Standard TMax Map                               b) Observed TMax Map                                   c) Difference TMax Map(Gold - Observed)"
   
    figure
    imagesc(g_array(:,:,1));
    colormap jet
    colorbar;
    
   
    map_heading_one =['a) Gold Standard ' label_name];
    title(map_heading_one);

    figure
    
    % make sure you fix this problem of unit and double. Why. where I am
    % wrong. As per soren I should be wrong.
    imagesc(g_array(:,:,1));
    colormap jet
    colorbar;
    map_heading_two =['b) Observed ' label_name];
    title(map_heading_two);

    figure;
    imagesc(g_array(:,:,1) - o_array(:,:,1));
    title('c) Difference Image');
    colormap jet
    colorbar;
    
    %% # Average TMax vs Delay
    
    figure;
    gh=plot(delay,o_val,'-*b','MarkerSize',5,'LineWidth',2.5);
    grid on;
    hold;
    oh=plot(delay,g_val,'-*r','MarkerSize',5,'LineWidth',1);
    
    head=[ 'oSVD mean ' label_name];
    title(head);
    xlabel('Delay Value(seconds)')
    head_one= ['Average ' label_name ' per delay(seconds)'];
    ylabel(head_one)
    
    legend('Location','north')
    head_two = ['Gold Standard ' label_name];
    set(gh,'DisplayName',head_two);
   
    head_three = ['Observed ' label_name];
    set(oh,'DisplayName',head_three);
    
    %% # MTT Map Comments

    if flag.oSVD.mtt == 1
        disp('Observed TMAX perfusion Maps in line with gold Standard oSVD Implementation');
    elseif flag.oSVD.mtt == 2
        disp('Observed TMAX perfusion Maps lag with a constant value from gold Standard oSVD Implementation');
    else
        disp('Observed TMAX perfusion Maps does not inline with gold Standard oSVD Implementation');
    end    

    
end



