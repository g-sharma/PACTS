function [  ] = print_maps(g_value,actual_value,d_value,label_name,gold_array,ob_array )
    options_doc_nocode.format = 'html';
    options_doc_nocode.showCode = false;
    publish('print_maps.m',options_doc_nocode);

    report_message=['Created on:' datestr(clock) '  for ' label_name  'MAPS'];
    disp(report_message);
    figure
    imagesc(gold_array(:,:,1));
    colormap jet
    colorbar;
    map_heading_one =['Gold Standard ' label_name];
    title(map_heading_one);

    figure
    imagesc(ob_array(:,:,1));
    colormap jet
    colorbar;
    map_heading_two =['Observed ' label_name];
    title(map_heading_two);

    figure;
    imagesc(gold_array(:,:,1) - ob_array(:,:,1));
    title('Difference Image');
    colormap jet
    colorbar;
    figure;
    gh=plot(d_value,actual_value,'-*b','MarkerSize',5,'LineWidth',2.5);
    grid on;
    hold;
    oh=plot(d_value,g_value,'-*r','MarkerSize',5,'LineWidth',1);
    
    head=['oSVD mean ' label_name];
    title(head);
    xlabel('Delay Value')
    head_one= ['Average ' label_name ' per delay'];
    ylabel(head_one)
    legend('Location','north')
    head_two = ['Gold Standard ' label_name]
    set(gh,'Displayname',head_two);
    head_three = ['Observed ' label_name]
    set(oh,'Displayname ',head_three);
    

end

