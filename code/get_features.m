% Local Feature Stencil Code
% CS 4495 / 6476: Computer Vision, Georgia Tech
% Written by James Hays

% Returns a set of feature descriptors for a given set of interest points. 

% 'image' can be grayscale or color, your choice.
% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
%   The local features should be centered at x and y.
% 'feature_width', in pixels, is the local feature width. You can assume
%   that feature_width will be a multiple of 4 (i.e. every cell of your
%   local SIFT-like feature will have an integer width and height).
% If you want to detect and describe features at multiple scales or
% particular orientations you can add input arguments.

% 'features' is the array of computed features. It should have the
%   following size: [length(x) x feature dimensionality] (e.g. 128 for
%   standard SIFT)

function [features] = get_features(image, x, y, feature_width)

% To start with, you might want to simply use normalized patches as your
% local feature. This is very simple to code and works OK. However, to get
% full credit you will need to implement the more effective SIFT descriptor
% (See Szeliski 4.1.2 or the original publications at
% http://www.cs.ubc.ca/~lowe/keypoints/)

% Your implementation does not need to exactly match the SIFT reference.
% Here are the key properties your (baseline) descriptor should have:
%  (1) a 4x4 grid of cells, each feature_width/4.
%  (2) each cell should have a histogram of the local distribution of
%    gradients in 8 orientations. Appending these histograms together will
%    give you 4x4 x 8 = 128 dimensions.
%  (3) Each feature should be normalized to unit length
%
% You do not need to perform the interpolation in which each gradient
% measurement contributes to multiple orientation bins in multiple cells
% As described in Szeliski, a single gradient measurement creates a
% weighted contribution to the 4 nearest cells and the 2 nearest
% orientation bins within each cell, for 8 total contributions. This type
% of interpolation probably will help, though.

% You do not have to explicitly compute the gradient orientation at each
% pixel (although you are free to do so). You can instead filter with
% oriented filters (e.g. a filter that responds to edges with a specific
% orientation). All of your SIFT-like feature can be constructed entirely
% from filtering fairly quickly in this way.

% You do not need to do the normalize -> threshold -> normalize again
% operation as detailed in Szeliski and the SIFT paper. It can help, though.

% Another simple trick which can help is to raise each element of the final
% feature vector to some power that is less than one.

% Placeholder that you can delete. Empty features.
features = zeros(size(x,2), 128);
directions = 0: pi/4 : 7*pi/4;
DandG = fspecial('gaussian',[1 9],3);
graX = imfilter(image, DandG);
graY = imfilter(image, DandG');
wholeDir = atan2(graY, graX);
magnitude = sqrt(graX .* graX + graY .* graY);
for ind = 1 : size(x,2)
    for knd = 1 : size(image,3)
        localM = magnitude(ceil(x(ind) - (feature_width / 2)) : ceil(x(ind) + (feature_width / 2 - 1)), ceil(y(ind) - feature_width / 2) : ceil(y(ind) + feature_width / 2 - 1),knd);
        localDir = wholeDir(ceil(x(ind) - (feature_width / 2)) : ceil(x(ind) + (feature_width / 2 - 1)), ceil(y(ind) - feature_width / 2) : ceil(y(ind) + feature_width / 2 - 1),knd);
%         graX = imfilter(graX, fspecial('gauss', [5 5], 1), 'symmetric');
%         graY = imfilter(graY, fspecial('gauss', [5 5], 1), 'symmetric');
%         magnitude = magnitude .* fspecial('gauss', [feature_width, feature_width], feature_width / 2);
        for iind = 1 : size(localM, 1)
            for jjnd = 1 : size(localM, 2)
                for kknd = 1 : 8
                        features(ind, ((ceil(iind / (feature_width / 4)) - 1) + (ceil(jjnd / (feature_width / 4)) - 1)* 4) * 8 + kknd) = features(ind, ((ceil(iind / (feature_width / 4)) - 1) + (ceil(jjnd / (feature_width / 4)) - 1)* 4) * 8 + kknd) + localM(iind, jjnd) .* cos(localDir(iind,jjnd) - directions(kknd));
                end
%                 if (abs(graX(iind, jjnd)) > abs(graY(iind, jjnd)))
%                     if (graX(iind, jjnd) > 0 && graY(iind, jjnd) > 0)
%                         setupbins{iind, jjnd} = [1 2];
%                     end
%                     if (graX(iind, jjnd) > 0 && graY(iind, jjnd) < 0)
%                         setupbins{iind, jjnd} = [1 8];
%                     end
%                     if (graX(iind, jjnd) < 0 && graY(iind, jjnd) > 0)
%                         setupbins{iind, jjnd} = [4 5];
%                     end
%                     if (graX(iind, jjnd) < 0 && graY(iind, jjnd) < 0)
%                         setupbins{iind, jjnd} = [5 6];
%                     end
%                     if (graX(iind, jjnd) == 0 && graY(iind, jjnd) == 0)
%                         setupbins{iind, jjnd} = [5 6];
%                     end
%                     if (graX(iind, jjnd) < 0 && graY(iind, jjnd) == 0)
%                         setupbins{iind, jjnd} = [5];
%                     end
%                     if (graX(iind, jjnd) > 0 && graY(iind, jjnd) == 0)
%                         setupbins{iind, jjnd} = [1];
%                     end
%                 else
%                     if (graX(iind, jjnd) >= 0 && graY(iind, jjnd) >= 0)
%                         setupbins{iind, jjnd} = [2 3];
%                     end
%                     if (graX(iind, jjnd) > 0 && graY(iind, jjnd) < 0)
%                         setupbins{iind, jjnd} = [7 8];
%                     end
%                     if (graX(iind, jjnd) < 0 && graY(iind, jjnd) > 0)
%                         setupbins{iind, jjnd} = [3 4];
%                     end
%                     if (graX(iind, jjnd) < 0 && graY(iind, jjnd) < 0)
%                         setupbins{iind, jjnd} = [6 7];
%                     end
%                     if (graX(iind, jjnd) == 0 && graY(iind, jjnd) == 0)
%                         setupbins{iind, jjnd} = [5 6];
%                     end
%                     if (graY(iind, jjnd) < 0 && graX(iind, jjnd) == 0)
%                         setupbins{iind, jjnd} = [7];
%                     end
%                     if (graY(iind, jjnd) > 0 && graX(iind, jjnd) == 0)
%                         setupbins{iind, jjnd} = [3];
%                     end
%                 end
            end
        end
%         graX = imfilter(graX, fspecial('gauss', [5 5], 1));
%         magnitude = imfilter(magnitude, fspecial('gauss', [5 5], 1), 'symmetric');
%         graX = graX .* fspecial('gauss', [feature_width, feature_width], 1);
%         graY = graY .* fspecial('gauss', [feature_width, feature_width], 1);
%         magnitude = magnitude .* fspecial('gauss', [feature_width, feature_width], 1);
%         for iind = 1 : size(graX,1)
%             for jjnd = 1 : size(graX,2)
%                 features{ind}{ceil(iind / 4), ceil(jjnd / 4)}(setupbins{iind, jjnd}) = features{ind}{ceil(iind / 4), ceil(jjnd / 4)}(setupbins{iind, jjnd}) + magnitude(iind, jjnd);
%             end
%         end
%         if (ceil(iind / 4) - 1 > 0)
%                     features{ind}{ceil(iind / 4 - 1), ceil(jjnd / 4)}(setupbins) = features{ind}{ceil(iind / 4 - 1), ceil(jjnd / 4)}(setupbins) + abs(graX(iind, jjnd)) + abs(graY(iind, jjnd));
%                 end
%                 if (ceil(iind / 4) + 1 < 5)
%                     features{ind}{ceil(iind / 4 + 1), ceil(jjnd / 4)}(setupbins) = features{ind}{ceil(iind / 4 + 1), ceil(jjnd / 4)}(setupbins) + abs(graX(iind, jjnd)) + abs(graY(iind, jjnd));
%                 end
%                 if (ceil(jjnd / 4) + 1 < 5)
%                     features{ind}{ceil(iind / 4), ceil(jjnd / 4) + 1}(setupbins) = features{ind}{ceil(iind / 4), ceil(jjnd / 4) + 1}(setupbins) + abs(graX(iind, jjnd)) + abs(graY(iind, jjnd));
%                 end
%                 if (ceil(jjnd / 4) - 1 > 0)
%                     features{ind}{ceil(iind / 4), ceil(jjnd / 4 - 1)}(setupbins) = features{ind}{ceil(iind / 4), ceil(jjnd / 4 - 1)}(setupbins) + abs(graX(iind, jjnd)) + abs(graY(iind, jjnd));
%                 end
    end
    features(ind,:) = features(ind,:) * (1/norm(features(ind,:), 2));
end




end








