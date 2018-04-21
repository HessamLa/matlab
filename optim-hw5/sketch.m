v = [1 2 1 2 5 3];
for i=1:sum(v)*10000
    I(i) = RouletteWheelSelection(v);
end

for i=1:6
    cnt(i) = sum(I==i);
end
cnt
