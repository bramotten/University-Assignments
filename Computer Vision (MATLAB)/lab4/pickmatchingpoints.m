function [xy, xaya] = pickmatchingpoints(im1, im2, n, figno)
% pickmatchingpoints
if nargin<3
    error('not enough parameters');
elseif nargin<4
    figno = gcf;
end
figure(figno);
clf;
subplot(1,2,1);
imshow(im1);
subplot(1,2,2);
imshow(im2);
xy = zeros(2,n);
xaya = zeros(2,n);
for i=1:n
    subplot(1,2,1);
    title(sprintf('Click at %d-th point in left image', i));
    xy(:,i) = ginput(1);
    text(xy(1,i), xy(2,i), sprintf('P %02d',i), 'Color', 'yellow');
    title('');
    
    subplot(1,2,2);
    title(sprintf('Click at %d-th point in right image', i));
    xaya(:,i) = ginput(1);
    text(xaya(1,i), xaya(2,i), sprintf('P %02d',i), 'Color', 'yellow');
    title('');
end
