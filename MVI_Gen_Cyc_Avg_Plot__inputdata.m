function [hx,ax] = MVI_Gen_Cyc_Avg_Plot__inputdata(Data,plotname,save_loc,stim_cond,Stim_data,legend_flag,SCC,Scale,plot_flag,invert_stim_flag,lr_xy_flag)


colors.l_x = [255 140 0]/255;
colors.l_y = [128 0 128]/255;
colors.l_z = [1 0 0];
colors.l_l = [0,128,0]/255;
colors.l_r = [0 0 1];

colors.r_x = [238 238 0]/255;
colors.r_y = [138 43 226]/255;
colors.r_z = [255,0,255]/255;
colors.r_l = [0 1 0];
colors.r_r = [64,224,208]/255;

if invert_stim_flag
    
    stimulus_mult = -1;
    stimulus_txt = 'Inverted Stimulus';
    stimulus_title_txt = '{Inverted Stim.}';
    
else
    
    stimulus_mult = 1;
    stimulus_txt = 'Stimulus';
    stimulus_title_txt = '';
end


hx = figure('units','normalized','outerposition',[0 0 1 1]);
%%

lhrh_max = [];
lhrh_min = [];
lhrh_max_sd = [];
lhrh_min_sd = [];

larp_max = [];
larp_min = [];
larp_max_sd = [];
larp_min_sd = [];

ralp_max = [];
ralp_min = [];
ralp_max_sd = [];
ralp_min_sd = [];

x_max = [];
x_min = [];
x_max_sd = [];
x_min_sd = [];

y_max = [];
y_min = [];
y_max_sd = [];
y_min_sd = [];


num_el = length(Data);

for k=1:num_el
    
    %     cd(raw{k,2})
    
    
    %     CycAvg = load([raw{k,1} '_CycleAvg.mat']);
    
    %     try
    CycAvg = Data(k).Data;
    %     catch
    %         CycAvg = CycAvg.Data;
    %     end
    
    if isfield(CycAvg,'CycAvg')
        Fs = CycAvg.CycAvg.Fs;
    else
        Fs = CycAvg.Fs;
    end
    
    
    h34_l = subplot(2,num_el,k);
    h34_r = subplot(2,num_el,k+num_el);
    len_l = length(CycAvg.ll_cycavg);
    len_r = length(CycAvg.lr_cycavg);
    subplot(h34_l)
    
    switch plot_flag
        case 1
            switch lr_xy_flag
                case 1
                    c1=plot([0:len_l-1]/CycAvg.Fs,CycAvg.ll_cycavg,'Color',colors.l_l,'LineWidth',2);
                    hold on
                    c2=plot([0:len_l-1]/CycAvg.Fs,CycAvg.lr_cycavg,'Color',colors.l_r,'LineWidth',2);
                case 2
                    c1=plot([0:len_l-1]/CycAvg.Fs,CycAvg.lx_cycavg,'Color',colors.l_x,'LineWidth',2);
                    hold on
                    c2=plot([0:len_l-1]/CycAvg.Fs,CycAvg.ly_cycavg,'Color',colors.l_y,'LineWidth',2);
            end
            c3=plot([0:len_l-1]/CycAvg.Fs,CycAvg.lz_cycavg,'Color',colors.l_z,'LineWidth',2);

        case 2
            switch lr_xy_flag
                case 1
                    c1=plot([0:len_l-1]/CycAvg.Fs,CycAvg.ll_cyc,'Color',colors.l_l,'LineWidth',1);
                    hold on
                    c2=plot([0:len_l-1]/CycAvg.Fs,CycAvg.lr_cyc,'Color',colors.l_r,'LineWidth',1);
                case 2
                    c1=plot([0:len_l-1]/CycAvg.Fs,CycAvg.lx_cyc,'Color',colors.l_x,'LineWidth',1);
                    hold on
                    c2=plot([0:len_l-1]/CycAvg.Fs,CycAvg.ly_cyc,'Color',colors.l_y,'LineWidth',1);
            end
            c3=plot([0:len_l-1]/CycAvg.Fs,CycAvg.lz_cyc,'Color',colors.l_z,'LineWidth',1);
    end
    set(gca,'xticklabel','');
    %     grid on
    if k~=1
        set(gca,'yticklabel','');
    else
        ylabel('Angular Velocity [°/s]')
    end
    %     set(gca,'Ytick',[-80:20:80]),grid on
    set(gca,'Ytick',[Scale(1) - 20:20:Scale(2) - 20]),grid on
    subplot(h34_r)
    
    switch plot_flag
        
        case 1
            switch lr_xy_flag
                case 1
                    c4=plot([0:len_r-1]/CycAvg.Fs,CycAvg.rl_cycavg,'Color',colors.r_l,'LineWidth',2);
                    hold on
                    c5=plot([0:len_r-1]/CycAvg.Fs,CycAvg.rr_cycavg,'Color',colors.r_r,'LineWidth',2);
                case 2
                    c4=plot([0:len_r-1]/CycAvg.Fs,CycAvg.rx_cycavg,'Color',colors.r_x,'LineWidth',2);
                    hold on
                    c5=plot([0:len_r-1]/CycAvg.Fs,CycAvg.ry_cycavg,'Color',colors.r_y,'LineWidth',2);
            end
            c6=plot([0:len_r-1]/CycAvg.Fs,CycAvg.rz_cycavg,'Color',colors.r_z,'LineWidth',2);
            lim = axis(h34_l);
            
        case 2
            switch lr_xy_flag
                case 1
                    c4=plot([0:len_r-1]/CycAvg.Fs,CycAvg.rl_cyc,'Color',colors.r_l,'LineWidth',1);
                    hold on
                    c5=plot([0:len_r-1]/CycAvg.Fs,CycAvg.rr_cyc,'Color',colors.r_r,'LineWidth',1);
                case 2
                    c4=plot([0:len_r-1]/CycAvg.Fs,CycAvg.rx_cyc,'Color',colors.r_x,'LineWidth',1);
                    hold on
                    c5=plot([0:len_r-1]/CycAvg.Fs,CycAvg.ry_cyc,'Color',colors.r_y,'LineWidth',1);
            end
            c6=plot([0:len_r-1]/CycAvg.Fs,CycAvg.rz_cyc,'Color',colors.r_z,'LineWidth',1);
            lim = axis(h34_l);
            
    end
    %     grid on
    %     set(gca,'Ytick',[-80:20:80]),grid on
    set(gca,'Ytick',[Scale(1) - 20:20:Scale(2) - 20]),grid on
    
    Stim_trace = Stim_data(k).Data;
    %     f = stim_cond(k);
    %     switch stim
    %
    %         case 1
    %             Stim_trace = Scale*sin(2*pi*f*[1:length(CycAvg.ll_cycavg)]/Fs);
    %
    %         case 2
    %             Stim_trace = ones(1,length(CycAvg.ll_cycavg));
    %             Stim_trace(1:round(train_dur*Fs)) = Scale*ones(1,length((1:round(train_dur*Fs))));
    %
    %     end
    
    subplot(h34_l)
    c6=plot([0:len_l-1]/Fs,Stim_trace*stimulus_mult,'k','LineWidth',2);
    subplot(h34_r)
    c6=plot([0:len_r-1]/Fs,Stim_trace*stimulus_mult,'k','LineWidth',2);
    
    
    
    
    linkaxes([h34_l h34_r])
    if k~=1
        set(gca,'yticklabel','');
    else
        
        ylabel('Angular Velocity [°/s]')
    end
    %     set(gca,'Ytick',[-80:20:80]),grid on
    set(gca,'Ytick',[Scale(1) - 20:20:Scale(2) - 20]),grid on
    
    xlabel('Time [s]')
    
    
    
    switch plot_flag
        
        case 1
            subplot(h34_l)
            plot([0:len_l-1]/CycAvg.Fs,zeros(1,len_l),'k')
            switch lr_xy_flag
                case 1
                    plot([0:len_l-1]/CycAvg.Fs,CycAvg.ll_cycavg + CycAvg.ll_cycstd,'Color',colors.l_l,'LineStyle','--','LineWidth',0.5)
                    plot([0:len_l-1]/CycAvg.Fs,CycAvg.lr_cycavg + CycAvg.lr_cycstd,'Color',colors.l_r,'LineStyle','--','LineWidth',0.5)
                case 2
                    plot([0:len_l-1]/CycAvg.Fs,CycAvg.lx_cycavg + CycAvg.lx_cycstd,'Color',colors.l_x,'LineStyle','--','LineWidth',0.5)
                    plot([0:len_l-1]/CycAvg.Fs,CycAvg.ly_cycavg + CycAvg.ly_cycstd,'Color',colors.l_y,'LineStyle','--','LineWidth',0.5)
            end
            plot([0:len_l-1]/CycAvg.Fs,CycAvg.lz_cycavg + CycAvg.lz_cycstd,'Color',colors.l_z,'LineStyle','--','LineWidth',0.5)
            switch lr_xy_flag
                case 1
                    plot([0:len_l-1]/CycAvg.Fs,CycAvg.ll_cycavg - CycAvg.ll_cycstd,'Color',colors.l_l,'LineStyle','--','LineWidth',0.5)
                    plot([0:len_l-1]/CycAvg.Fs,CycAvg.lr_cycavg - CycAvg.lr_cycstd,'Color',colors.l_r,'LineStyle','--','LineWidth',0.5)
                case 2
                    plot([0:len_l-1]/CycAvg.Fs,CycAvg.lx_cycavg - CycAvg.lx_cycstd,'Color',colors.l_x,'LineStyle','--','LineWidth',0.5)
                    plot([0:len_l-1]/CycAvg.Fs,CycAvg.ly_cycavg - CycAvg.ly_cycstd,'Color',colors.l_y,'LineStyle','--','LineWidth',0.5)
            end
            plot([0:len_l-1]/CycAvg.Fs,CycAvg.lz_cycavg - CycAvg.lz_cycstd,'Color',colors.l_z,'LineStyle','--','LineWidth',0.5)
            plot([0:len_l-1]/CycAvg.Fs,zeros(1,len_l),'k')
            
        case 2
            
            
    end
    %     num_str = num2str(f);
    title([stim_cond(k) stimulus_title_txt])
    
    if legend_flag
        switch lr_xy_flag
            case 1
                legend('LE-LARP','LE-RALP','LE-LHRH',stimulus_txt)
            case 2
                legend('LE-X','LE-Y','RE-Z',stimulus_txt)
        end
        
    end
    
    switch plot_flag
        
        case 1
            subplot(h34_r)
            switch lr_xy_flag
                case 1
                    plot([0:len_r-1]/CycAvg.Fs,CycAvg.rl_cycavg + CycAvg.rl_cycstd,'Color',colors.r_l,'LineStyle','--','LineWidth',0.5)
                    plot([0:len_r-1]/CycAvg.Fs,CycAvg.rr_cycavg + CycAvg.rr_cycstd,'Color',colors.r_r,'LineStyle','--','LineWidth',0.5)
                case 2
                    plot([0:len_r-1]/CycAvg.Fs,CycAvg.rx_cycavg + CycAvg.rx_cycstd,'Color',colors.r_x,'LineStyle','--','LineWidth',0.5)
                    plot([0:len_r-1]/CycAvg.Fs,CycAvg.ry_cycavg + CycAvg.ry_cycstd,'Color',colors.r_y,'LineStyle','--','LineWidth',0.5)
            end
            plot([0:len_r-1]/CycAvg.Fs,CycAvg.rz_cycavg + CycAvg.rz_cycstd,'Color',colors.r_z,'LineStyle','--','LineWidth',0.5)
            switch lr_xy_flag
                case 1
                    plot([0:len_r-1]/CycAvg.Fs,CycAvg.rl_cycavg - CycAvg.rl_cycstd,'Color',colors.r_l,'LineStyle','--','LineWidth',0.5)
                    plot([0:len_r-1]/CycAvg.Fs,CycAvg.rr_cycavg - CycAvg.rr_cycstd,'Color',colors.r_r,'LineStyle','--','LineWidth',0.5)
                case 2
                    plot([0:len_r-1]/CycAvg.Fs,CycAvg.rx_cycavg - CycAvg.rx_cycstd,'Color',colors.r_x,'LineStyle','--','LineWidth',0.5)
                    plot([0:len_r-1]/CycAvg.Fs,CycAvg.ry_cycavg - CycAvg.ry_cycstd,'Color',colors.r_y,'LineStyle','--','LineWidth',0.5)
            end
            plot([0:len_r-1]/CycAvg.Fs,CycAvg.rz_cycavg - CycAvg.rz_cycstd,'Color',colors.r_z,'LineStyle','--','LineWidth',0.5)
            plot([0:len_r-1]/CycAvg.Fs,zeros(1,len_r),'k')
            
            
        case 2
            
    end
    
    ylim([Scale(1) Scale(2)])
            xlim([0 (len_l-1)/Fs])
    if legend_flag
        switch lr_xy_flag
            case 1
                legend('RE-LARP','RE-RALP','RE-LHRH',stimulus_txt)
            case 2
                legend('RE-X','RE-Y','RE-Z',stimulus_txt)
        end
    end
    
    %     switch SCC
    %
    %         case 1 % LHRH
    %
    %             [max_lz,Imal] = max(abs(CycAvg.lz_cycavg(1:round(train_dur*Fs))));
    %             [max_rz,Imar] = max(abs(CycAvg.rz_cycavg(1:round(train_dur*Fs))));
    %             %     [min_lz,Imilz] = min(CycAvg.lz_cycavg);
    %             %     [min_rz,Imirz] = min(CycAvg.rz_cycavg);
    %
    %
    %
    %         case 2 % LARP
    %             [max_ll,Imal] = max(abs(CycAvg.ll_cycavg(1:round(train_dur*Fs))));
    %             [max_rl,Imar] = max(abs(CycAvg.rl_cycavg(1:round(train_dur*Fs))));
    %         case 3 % RALP
    %
    %             [max_lr,Imal] = max(abs(CycAvg.lr_cycavg(1:round(train_dur*Fs))));
    %             [max_rr,Imar] = max(abs(CycAvg.rr_cycavg(1:round(train_dur*Fs))));
    %     end
    %
    %
    %     lhrh_max = [lhrh_max ;  CycAvg.lz_cycavg(Imal) CycAvg.rz_cycavg(Imar)];
    %     %     lhrh_min = [lhrh_min ;  min_lz min_rz];
    %     lhrh_max_sd = [lhrh_max_sd ; CycAvg.lz_cycstd(Imal) CycAvg.rz_cycstd(Imar)];
    %     %     lhrh_min_sd = [lhrh_min_sd ; CycAvg.lz_cycstd(Imilz) CycAvg.rz_cycstd(Imilz)];
    %
    %      larp_max = [larp_max ;  CycAvg.ll_cycavg(Imal) CycAvg.rl_cycavg(Imar)];
    %     %     larp_min = [larp_min ;  min_lz min_rz];
    %     larp_max_sd = [larp_max_sd ; CycAvg.ll_cycstd(Imal) CycAvg.rl_cycstd(Imar)];
    %
    %      ralp_max = [ralp_max ;  CycAvg.lr_cycavg(Imal) CycAvg.rr_cycavg(Imar)];
    %     %     ralp_min = [ralp_min ;  min_lz min_rz];
    %     ralp_max_sd = [ralp_max_sd ; CycAvg.lr_cycstd(Imal) CycAvg.rr_cycstd(Imar)];
end

cd(save_loc)

plotname(strfind(plotname,'.')) = '_';

savefig(hx,[plotname '.fig'])
print(hx,plotname,'-dpng','-r300')


% h2 = figure('units','normalized','outerposition',[0 0 1 1])
% AX(1) = subplot(2,1,1)
%
% errorbar(stim_cond,lhrh_max(:,1),lhrh_max_sd(:,1),'Color',colors.l_z,'Marker','*','DisplayName','LE LHRH-Component','LineWidth',1)
% hold on
% errorbar(stim_cond,larp_max(:,1),larp_max_sd(:,1),'Color',colors.l_l,'Marker','*','DisplayName','LE LARP-Component','LineWidth',1)
% errorbar(stim_cond,ralp_max(:,1),ralp_max_sd(:,1),'Color',colors.l_r,'Marker','*','DisplayName','LE RALP-Component','LineWidth',1)
% set(gca,'xticklabel','');
% ylabel('Peak VOR Eye Velocity [\circ/s]')
% % legend('show','Postion',[0.222 0.476 0.149 0.098])
% legend('show')
%
% allXLim = get(AX, {'XLim'});
% allXLim = cat(2, allXLim{:});
% plot([min(allXLim):0.1:max(allXLim)],zeros(1,length([min(allXLim):0.1:max(allXLim)])),'LineStyle',':','color','k')
% grid on
% AX(2) = subplot(2,1,2),grid on
% errorbar(stim_cond,lhrh_max(:,2),lhrh_max_sd(:,2),'Color',colors.r_z,'Marker','*','DisplayName','RE LHRH-Component','LineWidth',1)
% hold on
% errorbar(stim_cond,larp_max(:,2),larp_max_sd(:,2),'Color',colors.r_l,'Marker','*','DisplayName','RE LARP-Component','LineWidth',1)
% errorbar(stim_cond,ralp_max(:,2),ralp_max_sd(:,2),'Color',colors.r_r,'Marker','*','DisplayName','RE RALP-Component','LineWidth',1)
% ylabel('Peak VOR Eye Velocity [\circ/s]')
%
% xlabel('Pulse Rate Amplitude [pps] (ON Duration: 200ms, OFF Duration: 300ms, Off Pulse Rate: 0pps)')
% ylabel('Peak VOR Eye Velocity [\circ/s]')
% legend('show')
% allYLim = get(AX, {'YLim'});
% allYLim = cat(2, allYLim{:});
%
% ylimset = [-80 80];
% set(AX, 'YLim', ylimset);
%
% allXLim = get(AX, {'XLim'});
% allXLim = cat(2, allXLim{:});
%
% set(AX,'Ytick',[-80:20:80])
%
% plot([min(allXLim):0.1:max(allXLim)],zeros(1,length([min(allXLim):0.1:max(allXLim)])),'LineStyle',':','color','k')
% grid on
%
%
% savefig(h2,[plotname '_Summary.fig'])
% print(h2,[plotname '_Summary'],'-dpng','-r300')



end