%%
function [yy,coefs]= voma_smooth(x,y,p,xx,LinExtrap,d2)
% SMOOTH Calculates a smoothing spline.
%
%  CALL:  yy = smooth(x,y,p,xx,def,d2)
%
%         x  = x-coordinates of data.
%         y  = y-coordinates of data.
%         p  = [0...1] is a smoothing parameter:
%              0 -> LS-straight line
%              1 -> cubic spline interpolant
%         xx = the x-coordinates in which to calculate the smoothed function.
%         yy = the calculated y-coordinates of the smoothed function.
%        def = 0 regular smoothing spline (default)
%              1 a smoothing spline with a constraint on the ends to
%                ensure linear extrapolation outside the range of the data
%         d2 = variance of each y(i) (default  ones(length(X),1))
%
%  Given the approximate values
%
%                y(i) = g(x(i))+e(i)
%
%  of some smooth function, g, where e(i) is the error. Smooth tries to
%  recover g from y by constructing a function, f, which  minimizes
%
%              p * sum (Y(i) - f(X(i)))^2/d2(i)  +  (1-p) * int (f'')^2
%
%  The call  pp = smooth(x,y,p)  gives the pp-form of the spline,
%  for use with PPVAL.
%
% See also: lc2tr, dat2tr



if (nargin<5)||(isempty(LinExtrap)),
  LinExtrap=0; %do not force linear extrapolation in the ends (default)
else
  LinExtrap=LinExtrap;
end
n=length(x);

[xi,ind]=sort(x);xi=xi(:);

if n<2,
  error('There must be >=2 data points.')
elseif ~all(diff(xi)),
  error('Two consecutive values in x can not be equal.')
elseif n~=length(y),
  error('x and y must have the same length.')
end

if nargin<6||isempty(d2),
  d2 = ones(n,1);  %not implemented yet
else
  d2=d2(:);
end


yi=y(ind); yi=yi(:);

dx=diff(xi);
if (LinExtrap && (n>6) && (p~=0)),
  Q=spdiags([1./dx(2:n-3) -(1./dx(2:n-3)+1./dx(3:n-2)) ...
    1./dx(3:n-2)],0:-1:-2,n-2,n-4);
  D=spdiags(d2(2:n-1),0,n-2,n-2); % The variance
else
  Q=spdiags([1./dx(1:n-2) -(1./dx(1:n-2)+1./dx(2:n-1)) ...
    1./dx(2:n-1)],0:-1:-2,n,n-2);
  D=spdiags(d2(:),0,n,n);  % The variance
end
if (n==2) || ((p==0) && (nargin<6)), % LS-straight line
  ai=yi-Q*(Q\yi);
  coefs=[diff(ai)./dx ai(1:n-1)];
else
  if LinExtrap && n>6 && (p~=0), %forcing linear extrapolation in the ends
    % new call : so ci(1:2)=ci(n-1:n)=di(1)=di(n)=0
    R=spdiags([dx(2:n-3) 2*(dx(2:n-3)+dx(3:n-2)) dx(3:n-2)],-1:1,n-4,n-4);

    QQ=(6*(1-p))*(Q.'*D*Q)+p*R;
    % Make sure Matlab uses symmetric matrix solver
    u=2*((QQ+QQ')\diff(diff(yi(2:n-1))./dx(2:n-2))); %faster than 2*(QQ+QQ.'')\(Q'*yi);

    % The piecewise polynominals are written as
    % fi=ai+bi*(x-xi)+ci*(x-xi)^2+di*(x-xi)^3
    ai=yi(2:n-1)-(6*(1-p)*D*diff([0;diff([0;u;0])./dx(2:n-2);0]));%faster than yi-6*(1-p)*D*Q*u ;
    ci=3*p*[0;0;u;0];
    % fixing the coefficients so that we have contionous
    % derivatives everywhere
    a1=-(ai(2)-ai(1))*dx(1)/dx(2) +ai(1)+ ci(3)*dx(1)*dx(2)/3;
    an=(ai(n-2)-ai(n-3))*dx(n-1)/dx(n-2) +ai(n-2)+ ci(n-2)*dx(n-2)*dx(n-1)/3;
    ai=[a1;ai; an];

  else
    R=spdiags([dx(1:n-2) 2*(dx(1:n-2)+dx(2:n-1)) dx(2:n-1)],-1:1,n-2,n-2);
    QQ=(6*(1-p))*(Q.'*D*Q)+p*R;
    % Make sure Matlab uses symmetric matrix solver
    u=2*((QQ+QQ')\diff(diff(yi)./dx)); % faster than u=QQ\(Q'*yi);
    ai=yi-6*(1-p)*D*diff([0;diff([0;u;0])./dx;0]);%faster than yi-6*(1-p)*Q*u

    %derivatives in the knots according to Carl de Boor
    %    dfi=6*p*[0;u];
    %    ddfi=diff([ci;0])./dx;
    %    dddfi=diff(ai)./dx-(ci/2+di/6.*dx).*dx;
    % thus the coefficients for the piecewise polynominals
    %fi(x)=ai+bi*(x-xi)+ci*(x-xi)^2+di*(x-xi)^3 are
    ci=3*p*[0;u];

  end
  % old call: linear extrapolation
  % crude the derivatives are not necessarily continous
  % where we force ci and di to zero
  %if LinExtrap, %forcing linear extrapolation in the ends
  %  ci([2,  end])=0;  % could be done better
  %  %di([1 end])=0;
  %end
  di=diff([ci;0])./dx/3;

  bi=diff(ai)./dx-(ci+di.*dx).*dx;
  coefs=[di ci bi ai(1:n-1)];
end

pp=mkpp(xi,coefs);

if (nargin<4)||(isempty(xx)),
  yy=pp;
else
  yy=ppval(pp,xx);
end
end

