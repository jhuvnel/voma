function sync = denoiseSync(TS_intervalS,TS_idxS)
%%
a = 1./TS_intervalS;
aa = TS_idxS./1000;
a(a==Inf)=0;
b=abs(diff(a));
c=b>100;
d = [];
dd = [];
e = 0;
for f = 1:length(c)
    if c(f)>0
        e = e+1;
        if e == 1
            d = f;
        end
    else
        if e>4
            dd = [dd;d f];
        end
        e = 0;
    end
end
figure
plot(aa,a)
hold on
%%
if isempty(dd)
    sync = smooth(aa,a,0.002,'rloess');
                            sync(sync>420) = 0;
                            sync(sync<0) = 0;
%                             ss = find(sync>61);
%                             sync2 = a;
%                             sync2(ss) = sync(ss);
%                             sync = sync2;
                            plot(aa,sync)
else
ff = dd(2:end,1)-dd(1:end-1,2);
gg = find(ff>10)+1;
dd(gg,:)=[];
if isempty(gg)
    sync = smooth(aa,a,0.002,'rloess');
                            sync(sync>420) = 0;
                            sync(sync<0) = 0;
%                             ss = find(sync>61);
%                             sync2 = a;
%                             sync2(ss) = sync(ss);
%                             sync = sync2;
                            plot(aa,sync)
else
%%
g = a;
sz = size(dd);
for h = 1:sz(1)
    g(dd(h,1):dd(h,2)) = 200;
end
plot(aa,g)
%%
                            sync = smooth(aa,g,0.002,'rloess');
                            sync(sync>420) = 0;
                            sync(sync<0) = 0;
%                             ss = find(sync>61);
%                             sync2 = a;
%                             sync2(ss) = sync(ss);
%                             sync = sync2;
                            plot(aa,sync)
                           
end
end
pause(1)
close(gcf)
hold off