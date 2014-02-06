
%% # Testgui Report sSVD (MTT,TMax) maps
load ~/PACTS/MR/MAT/results.mat;
load ~/PACTS/MR/MAT/
delay =0:2:12;


if sSVD_mtt ~= -1
    g_val=[26.6814   15.6701   12.0697   10.2197    9.1348    8.4286    7.9597];
    o_val = sSVD.mtt_tileValues_slice_one;
    g_array = results.smttmap; 
    o_array = cast(pha_sSVD_mtt,'double');
    differece = roundn((o_val - g_val),-1);
    if range(differece) == 0
        if differece(1) == 0
            flag.sSVD.mtt = 1;
        else
            flag.sSVD.mtt = 2;
        end
    else
        flag.sSVD.mtt = 3;
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
    
    head=[ 'sSVD mean ' label_name];
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

    if flag.sSVD.mtt == 1
        disp('Observed MTT perfusion Maps in line with gold Standard sSVD Implementation');
    elseif flag.sSVD.mtt == 2
        disp('Observed MTT perfusion Maps lag with a constant value from gold Standard sSVD Implementation');
    else
        disp('Observed MTT perfusion Maps does not inline with gold Standard sSVD Implementation');
    end    


end


    

if sSVD_tmax ~= -1
    g_val=[ 5.9143    7.4571    9.2571   11.5714   13.1143   15.1714   17.2286];
    o_val = sSVD.tmax_tileValues_slice_one;
    g_array = results.sdelaymap; 
    o_array = pha_sSVD_tmax;
    differece = roundn((o_val - g_val),-1);
    if range(differece) == 0
        if differece(1) == 0
            flag.sSVD.tmax = 1;
        else
            flag.sSVD.tmax = 2;
        end
    else
        flag.sSVD.tmax = 3;
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
    
    head=[ 'sSVD mean ' label_name];
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

    if flag.sSVD.mtt == 1
        disp('Observed TMAX perfusion Maps in line with gold Standard sSVD Implementation');
    elseif flag.sSVD.mtt == 2
        disp('Observed TMAX perfusion Maps lag with a constant value from gold Standard sSVD Implementation');
    else
        disp('Observed TMAX perfusion Maps does not inline with gold Standard sSVD Implementation');
    end    

    
end



