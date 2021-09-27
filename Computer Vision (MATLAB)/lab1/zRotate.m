%%
function zRotate(phi, points)
matrix = rot(phi)
for i = 1:size(points)
    rotpoint = matrix*transpose(points(i,:))
end
end