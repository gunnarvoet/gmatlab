function gpcf(x,y,A)

if nargin<2
A = x;
pcolor(A)
shading flat
else
pcolor(x,y,A)
shading flat
end