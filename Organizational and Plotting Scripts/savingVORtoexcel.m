%%
% s5r11V = [];
% s5r11amp = [];
% s5r11Ind = 108:117;
% s14r11V = [];
% s14r11amp = [];
% s14r11Ind = 308:317;
% for i = 1:10
%     s5r11V = [s5r11V tempS(s5r11Ind(i)).MagL];
%     s5r11amp = [s5r11amp repmat(tempS(s5r11Ind(i)).p1amp,1,length(tempS(s5r11Ind(i)).MagL))];
%     s14r11V = [s14r11V tempS(s14r11Ind(i)).MagL];
%     s14r11amp = [s14r11amp repmat(tempS(s14r11Ind(i)).p1amp,1,length(tempS(s14r11Ind(i)).MagL))];
% end
s14r11V = [2.12525042174310,3.53200837938633,8.25499571046892,17.5254936542354,...
                 35.3219241324939,56.7803511232669,74.7161589600999,107.895073474222,...
                 124.305309274030,146.351117497473];
s5r11V = [1.52660430191998,2.61030295557887,6.83023019251766,17.3324849447315,...
                31.0890457647527,53.5090725171363,75.7346069436185,106.452886777757,...
                134.845553436567,151.386670964153];
             s14r11amp = [25,50,75,100,125,150,175,200,225,250];
             s5r11amp = [25,50,75,100,125,150,175,200,225,250];
y = [s14r11V s5r11V]';
x1 = [s14r11amp s5r11amp]';
x2 = [zeros(1,length(s14r11V)) ones(1,length(s5r11V))]';
tbl = table(y,x1,x2,'VariableNames',{'y','x1','x2'});
% figure
% plot(s14r11amp,s14r11V,'bo')
% hold on
% plot(s5r11amp,s5r11V,'go')
%lms14 = fitlm(tbl(tbl.x2==0,:),'y~x1')
%lms5 = fitlm(tbl(tbl.x2==1,:),'y~x1')
altglme = fitlm(tbl,'y~x1*x2')
glme = fitlm(tbl,'y~x1')

%results = compare(lmRed,lmFull)
%X = [ones(size(x1)) x1 x2 x1.*x2];
%[b,bint,r,rint,stats] = regress(y,X)
%%
load carsmall
x1 = Weight
x2 = Horsepower
y = MPG
X = [ones(size(x1)) x1 x2 x1.*x2];
%%
filename = 'nancyData.xlsx'
amp = [];
v = [];
m = [];
exprtNum = 1;
for i = 1:length(tempS)
    if i == 1
        prevComb = tempS(i).eCombs;
        amp = [amp; repmat(tempS(i).p1amp,length(tempS(i).MagL),1)];
        v = [v; tempS(i).MagL'];
        m = [m; tempS(i).MisalignL'];
    else
        if i<length(tempS)
            if ~isequal(prevComb,tempS(i+1).eCombs)
                amp = [amp; repmat(tempS(i).p1amp,length(tempS(i).MagL),1)];
                v = [v; tempS(i).MagL'];
                m = [m; tempS(i).MisalignL'];
                name = ['stim',num2str(tempS(i).stim),'ref',num2str(tempS(i).ref)];
                tbl = table(amp,v,m,'VariableNames',{[name,'AMP'],[name,'V'],[name,'M']});
                cells = xlscol([1+3*(exprtNum-1) 3+3*(exprtNum-1)]);
                writetable(tbl,filename,'Range',[cells{1},':',cells{2}])
                exprtNum = exprtNum +1;
                amp = [];
                v = [];
                m = [];
                prevComb = tempS(i+1).eCombs
            else
                amp = [amp; repmat(tempS(i).p1amp,length(tempS(i).MagL),1)];
                v = [v; tempS(i).MagL'];
                m = [m; tempS(i).MisalignL'];
            end
        else
            amp = [amp; repmat(tempS(i).p1amp,length(tempS(i).MagL),1)];
                v = [v; tempS(i).MagL'];
                m = [m; tempS(i).MisalignL'];
                name = ['stim',num2str(tempS(i).stim),'ref',num2str(tempS(i).ref)];
                tbl = table(amp,v,m,'VariableNames',{[name,'AMP'],[name,'V'],[name,'M']});
                cells = xlscol([1+3*(exprtNum-1) 3+3*(exprtNum-1)]);
                writetable(tbl,filename,'Range',[cells{1},':',cells{2}])
                done = 1
        end
    end
end