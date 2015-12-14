function y = ApplyClassThreshold(h, x)
% Modified from Copyright (c) 2010, Dirk-Jan Kroon. All rights reserved.
% Function is written by D.Kroon University of Twente (August 2010)
% See license.txt

% Draw a line in one dimension (like horizontal or vertical)
% and classify everything below the line to one of the 2 classes
% and everything above the line to the other class.
if(h.direction == 1)
    y =  double(x(:,h.feature) >= h.threshold);
else
    y =  double(x(:,h.feature) < h.threshold);
end
y(y==0) = -1;
end