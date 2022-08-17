%%
ox = readtable('C:\Users\Brian\Desktop\Solidworks Add Ins\OrigX.csv');
oy = readtable('C:\Users\Brian\Desktop\Solidworks Add Ins\OrigY.csv');
cx = readtable('C:\Users\Brian\Desktop\Solidworks Add Ins\CurX.csv');
cy = readtable('C:\Users\Brian\Desktop\Solidworks Add Ins\CurY.csv');
cnx = readtable('C:\Users\Brian\Desktop\Solidworks Add Ins\CurNewX.csv');
cny = readtable('C:\Users\Brian\Desktop\Solidworks Add Ins\CurNewY.csv');
sx = readtable('C:\Users\Brian\Desktop\Solidworks Add Ins\ShiftX.csv');
sy = readtable('C:\Users\Brian\Desktop\Solidworks Add Ins\ShiftY.csv');
is = readtable('C:\Users\Brian\Desktop\Solidworks Add Ins\OrigInds.csv');
bp = readtable('C:\Users\Brian\Desktop\Solidworks Add Ins\BoundPoints.csv');
tt = readtable('C:\Users\Brian\Desktop\Solidworks Add Ins\tt.csv');
pt = readtable('C:\Users\Brian\Desktop\Solidworks Add Ins\pts.csv');
%%
fox = fields(ox);
foy = fields(oy);
fcx = fields(cx);
fcy = fields(cy);
fcnx = fields(cnx);
fcny = fields(cny);
fsx = fields(sx);
fsy = fields(sy);
fis = fields(is);
fbp = fields(bp);
ftt = fields(tt);
fpt = fields(pt);
%%
figure
p1 = polyshape(bp.(fbp{1}),bp.(fbp{2}));
    p1p = plot(p1,'FaceColor','k');
    hold on
    plot(bp.(fbp{1}),bp.(fbp{2}),'k*','MarkerSize',10)
    p1 = polyshape(bp.(fbp{4}),bp.(fbp{5}));
    p1p = plot(p1,'FaceColor','b');
    plot(bp.(fbp{4}),bp.(fbp{5}),'b*','MarkerSize',10)
%%
bps = struct();
mv = 0;
for i = 1:(length(fbp)-3)/3
    xi = 1+3*(i-1);
    yi = 2+3*(i-1);
    x = bp.(fbp{xi})(~isnan(bp.(fbp{xi})));
    y = bp.(fbp{yi})(~isnan(bp.(fbp{yi})));
    bps.p(i).x = x;
    bps.p(i).y = y;
    xp = max(x)-(max(x)-min(x))/2;
    yp = max(y)-(max(y)-min(y))/2;
    bps.p(i).xp = xp;
    bps.p(i).yp = yp;
    a = [x y zeros(length(x),1)]-[xp yp 0];
    b = repmat([0 yp+10 0],length(x),1);
    n = repmat([0 0 1],length(x),1);
    aa = vecangle360(a,b,n);
    bps.p(i).ang = aa;
    bps.p(i).dis = vecnorm(a,2,2);
    mvp = mv;
    mv = max(mv,length(x));
    if mvp ~= mv
        if i > 1
            bps.p(find([bps.p.max] == 1)).max = 0;
        end
                bps.p(i).max = 1;
    else
        bps.p(i).max = 0;
    end
end
%%
sp = find([bps.p.max] == 1)-1;
figure
xtu = [];
ytu = [];
xtu = [xtu bps.p(sp).x];
ytu = [ytu bps.p(sp).y];

if (sp == length(bps.p)-1)
    for i = sp-1:-1:1
        p1 = polyshape(bps.p(i).x,bps.p(i).y);
    p1p = plot(p1,'FaceColor','k');
    hold on
    plot(bps.p(i).x,bps.p(i).y,'k*','MarkerSize',10)
    xtut = [];
    ytut = [];
        for j = 1:length(bps.p(sp).ang)
            ang2f = bps.p(sp).ang(j);
            sa = sort(bps.p(i).ang)
            angs = [bps.p(i).ang]-ang2f;
            [~,ii]=mink(abs(angs),2)
            farD = max(bps.p(i).dis(ii));
            x1 = [bps.p(i).xp farD*sin(ang2f*(pi/180))+bps.p(i).xp];
            y1 = [bps.p(i).yp farD*cos(ang2f*(pi/180))+bps.p(i).yp];
            ds = sqrt((bps.p(i).x-x1(2)).^2+(bps.p(i).y-y1(2)).^2);
            [~,ii2] = mink(ds,2)
            plot(x1,y1)
            x2 = [bps.p(i).x(ii(1)) bps.p(i).x(ii(2))];
            y2 = [bps.p(i).y(ii(1)) bps.p(i).y(ii(2))];
            plot(x2,y2)
            [xn,yn] = polyxpoly(x1,y1,x2,y2);
            xn
            xtut = [xtut; xn];
            ytut = [ytut; yn];
        end
        xtu = [xtu xtut];
        ytu = [ytu ytut];
    end
else
end

%%
figure
minX = [];
maxX = [];
minY = [];
maxY = [];
for i = 1:length(fox)-3
    
    p1 = polyshape(ox.(fox{i}),oy.(foy{i}));
    p1p = plot(p1,'FaceColor','k');
    hold on
    plot(ox.(fox{i}),oy.(foy{i}),'k*','MarkerSize',10)
    shX = sx.(fsx{i})(i);
    shY = sy.(fsy{i})(i);
    p2 = polyshape(ox.(fox{i})-shX,oy.(foy{i})-shY);
    plot(p2,'FaceColor','y')
    plot(ox.(fox{i})-shX,oy.(foy{i})-shY,'y*')
    input('');
    p3 = polyshape(cx.(fcx{i}),cy.(fcy{i}));
    p3p = plot(p3);
    plot(cx.(fcx{i}),cy.(fcy{i}),'r*','Color',p3p.FaceColor);
    input('');
    p4 = polyshape(cnx.(fcnx{i}),cny.(fcny{i}));
    p4p = plot(p4,'FaceColor','g');
    plot(cnx.(fcnx{i}),cny.(fcny{i}),'r*','Color',p4p.FaceColor);
    plot(mean(cnx.(fcnx{i}),'omitnan'),mean(cny.(fcny{i}),'omitnan'),'r*','Color',p4p.FaceColor,'MarkerSize',10);
    input('');
    %pause(1)
end
%%
orderAX = [];
orderAY = [];
orderCX = [];
orderCY = [];
orderAX = [orderAX pt.(fpt{4})(1)];
orderAY = [orderAY pt.(fpt{5})(1)];
orderCX = [orderCX pt.(fpt{4})(2:end)];
orderCY = [orderCY pt.(fpt{5})(2:end)];
i = 1;
go = 1;
while go
    di = sqrt((orderCX - orderAX(end)).^2 + (orderCY - orderAY(end)).^2); 
    [a,b] = min(di);
    orderAX = [orderAX orderCX(b)];
    orderAY = [orderAY orderCY(b)];
    orderCX(b) = [];
    orderCY(b) = [];
    if isempty(orderCX)
        go = 0;
    end
end
figure
p1 = polyshape(orderAX,orderAY);
    plot(p1)
    hold on
plot(orderAX,orderAY,'b*')

%%
figure
minX = [];
maxX = [];
minY = [];
maxY = [];
pts = 1:4:2017;
for i = 1%(length(fbp)-3)/2%:length(fox)-11

p1 = polyshape(bp.(fbp{i+(i-1)}),bp.(fbp{i+1+(i-1)}));
    plot(p1)
    hold on
plot(tt.(ftt{13})(pts+(i-1))*1000,tt.(ftt{14})(pts+(i-1))*1000,'b*')
pause(1)

end
%%
allI = struct();
for i = 1:length(fox)-3
    newI = [];
    ci = is.(fis{i})(~isnan(is.(fis{i})));
    cis = sort(ci);
    cis'
    ciall = cx.(fcx{i})(~isnan(cx.(fcx{i})));
            dci = diff(cis);
            dci'
        [a,b] = max(dci);
    if any(cis==0)
%         dci = diff(ci);
%         [a,b] = max(dci);
        if any(cis == length(ciall)-1)
            bps = find(dci>6);
            for i2 = min(cis):cis(bps(1))
                newI = [newI i2];
            end
            for i2 = cis(bps(1)+1):cis(bps(2))
                newI = [newI i2];
            end
            for i2 = cis(bps(2)+1):max(cis)
                newI = [newI i2];
            end
           
        else
            for i2 = min(cis):cis(b)
                newI = [newI i2];
            end
            for i2 = cis(b+1):max(cis)
                newI = [newI i2];
            end
        end
    else
%         dci = diff(ci);
%         [a,b] = max(dci);
        if max(dci)>5
            ad2 = 0;
            ad3 = 0;
            if (cis(b) - min(cis)) > (max(cis) - cis(b+1))
                if (max(cis) - cis(b+1)) < 15
                    %ad3 = 15 - (max(cis) - cis(b+1));
                end
            else
                if (cis(b) - min(cis)) < 15
                    %ad2 = 15 - (cis(b) - min(cis));
                end
            end
            for i2 = min(cis):cis(b)+ad2
                newI = [newI i2];
            end
            for i2 = cis(b+1)-ad3:max(cis)
                newI = [newI i2];
            end
        else
            for i2 = min(cis):max(cis)
                newI = [newI i2];
            end
        end
    end
    allI(i).Inds = newI;
    figure
    cxnn = cx.(fcx{i})(~isnan(cx.(fcx{i})));
    cynn = cy.(fcy{i})(~isnan(cy.(fcy{i})));
    p2 = polyshape(cxnn,cynn);
    plot(p2)
    hold on
    plot(cxnn(cis+1),cynn(cis+1),'r*','markersize',5)
    plot(cxnn(newI+1),cynn(newI+1),'go','markersize',10)
    hold off
    blah = 1;
end
%%
figure
minX = [];
maxX = [];
minY = [];
maxY = [];
for i = 1length(fox)-5:length(fox)-3%:length(fox)-11

p1 = polyshape(ox.(fox{i})-sx.(fsx{i})(i,1),oy.(foy{i})-sy.(fsy{i})(i,1));
    p2 = polyshape(cx.(fcx{i}),cy.(fcy{i}));
    plot(p1)
    hold on
    plot(p2)
plot(cnx.(fcnx{i}),cny.(fcny{i}),'r*')
mean(cnx.(fcnx{i}),'omitnan')
mean(cny.(fcny{i}),'omitnan')
plot(mean(cnx.(fcnx{i}),'omitnan'),mean(cny.(fcny{i}),'omitnan'),'g*', 'markersize',10)
if (i > 1)
    minX = [minX (min(cx.(fcx{i-1}))-min(cx.(fcx{i})))];
    maxX = [maxX (max(cx.(fcx{i-1}))-max(cx.(fcx{i})))];
    minY = [minY (min(cy.(fcy{i-1}))-min(cy.(fcy{i})))];
    maxY = [maxY (max(cy.(fcy{i-1}))-max(cy.(fcy{i})))];
end
pause(1)
end
%%


x1 = Th.PtSketchX;
y1 = Th.PtSketchY;

x2 = Tb.PtSketchX;
y2 = Tb.PtSketchY;
its = 1;
while its <3
    f = figure;
    p1 = polyshape(x1,y1);
    p2 = polyshape(x2,y2);
    plot(p1)
    hold on
    plot(p2)
    plot(mean(x1),mean(y1),'r*')
    c = zeros(1,length(x2));
    dist = zeros(1,length(x2));
    dx = zeros(1,length(x1));
    dy = zeros(1,length(x1));
    matched = [];
    for i = 1:length(x1)
        [tempD,tempI] = min(sqrt((x2-x1(i)).^2+(y2-y1(i)).^2));
        c(tempI) = i;
        dist(tempI) = tempD;
        dx(i) = (x2(tempI)-x1(i));
        dy(i) = (y2(tempI)-y1(i));
        plot([x1(i) x2(tempI)],[y1(i) y2(tempI)],'r-')
        matched = [matched tempI];
    end
    x1 = x1+mean(abs(dx));
    y1 = y1+mean(abs(dy));
    its = its+1;
    hold off
    
end
%%
bw = poly2mask(round(Th.PtSketchX,1)*10,round(Th.PtSketchY,1)*10,5120,5120);
bw2 = poly2mask(round(Tb.PtSketchX,1)*10,round(Tb.PtSketchY,1)*10,5120,5120);
figure
imshow(bw)
hold on
plot(round(Th.PtSketchX,1)*10,round(Th.PtSketchY,1)*10,'b','LineWidth',2)
hold off
figure
imshow(bw2)
hold on
plot(round(Tb.PtSketchX,1)*10,round(Tb.PtSketchY,1)*10,'r','LineWidth',2)
hold off
%%
addpath(genpath(pwd))
load('bunny_set.mat')
SDM_FFD_N(Tdata0,Tdata2)
%%

b1 = [Th.PtSketchX Th.PtSketchY];
b2 = [Tb.PtSketchX Tb.PtSketchY];
SDM_FFD_N(b1,b2)
%%
function a = vecangle360(v1,v2,n)
x = cross(v1,v2,2);
c = sign(dot(x,n,2)) .* vecnorm(x,2,2);
a = atan2d(c,dot(v1,v2,2));
a(a<0) = a(a<0)+360;
end