function PlotPotemtialMap(V_in,hm)
[dim1, ~]=size(V_in);
for i=1:dim1
    a=sprintf('Estiantion %d',i);
    showpotentials(V_in(i,:)',hm)
    title(a)
end
end