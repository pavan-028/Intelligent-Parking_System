function [test]= Numcorrel(varargin)

h=zeros(1,length(varargin{1,1}));
x=zeros(1,length(varargin{1,1}));
w=zeros(1,length(varargin{1,1}));

if (length(varargin{1,1}))==7
for n=1: length(varargin{1,1})

h(n)=varargin{1}(n,1).BoundingBox(4);
w(n)=varargin{1}(n,1).BoundingBox(3);
x(n)=varargin{1}(n,1).BoundingBox(1);
end 
% plot(x,h,'r')
% hold on
% plot(x,w,'b')
% axis([x(1) x(end)  1 h(end)+50  ])
Htest=100*((h-median(h)))/median(h);
Wtest=100*((w-median(w)))/median(w);
end

if length(varargin{1,1})~=7
    test=0;
elseif sum(abs(Htest)>15)||sum(abs(Wtest)>58)
    test=0;
else
    test=1;
end

end