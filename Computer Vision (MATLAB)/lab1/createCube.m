% creates a unit cube at scale scale arount center point t
function faces = createCube(scale, t)
    faces = zeros(6, 5, 3);
    % a number of polygons defining an axis-aligned unit cube around the origin
    % faces is a 6x5x3 array containing 6 faces with 5 points each with 3
    % coordinates each
    % upper face
    faces(1, :, 1) = [-0.5, 0.5, 0.5, -0.5, -0.5];
    faces(1, :, 2) = [-0.5, -0.5, 0.5, 0.5, -0.5];
    faces(1, :, 3) = [0.5, 0.5, 0.5, 0.5, 0.5];
    % right face
    faces(2, :, 1) = [0.5, 0.5, 0.5, 0.5, 0.5];
    faces(2, :, 2) = [-0.5, 0.5, 0.5, -0.5, -0.5];
    faces(2, :, 3) = [-0.5, -0.5, 0.5, 0.5, -0.5];
    % back face
    faces(3, :, 1) = [-0.5, 0.5, 0.5, -0.5, -0.5];
    faces(3, :, 2) = [0.5, 0.5, 0.5, 0.5, 0.5];
    faces(3, :, 3) = [-0.5, -0.5, 0.5, 0.5, -0.5];
    % front face
    faces(4, :, 1) = [-0.5, 0.5, 0.5, -0.5, -0.5];
    faces(4, :, 2) = [-0.5, -0.5, -0.5, -0.5, -0.5];
    faces(4, :, 3) = [-0.5, -0.5, 0.5, 0.5, -0.5];
    % left face
    faces(5, :, 1) = [-0.5, -0.5, -0.5, -0.5, -0.5];
    faces(5, :, 2) = [-0.5, 0.5, 0.5, -0.5, -0.5];
    faces(5, :, 3) = [-0.5, -0.5, 0.5, 0.5, -0.5];
    % lower face
    faces(6, :, 1) = [-0.5, 0.5, 0.5, -0.5, -0.5];
    faces(6, :, 2) = [-0.5, -0.5, 0.5, 0.5, -0.5];
    faces(6, :, 3) = [-0.5, -0.5, -0.5, -0.5, -0.5];
    
    faces = faces.*scale;
    for i=1:3
        faces(:, :, i) = faces(:, :, i) + t(i);
    end