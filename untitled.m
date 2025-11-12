close all;

% For grayscale dot mosaic
im = im2double(rgb2gray(imread('one.jpg')));
% resize if necessary
mosaic = dot_mosaic_gray(im, 50);  % Choose Size carefully!
figure; montage({im, mosaic});

% For grayscale dot mosaic
im = im2double(rgb2gray(imread('two.jpg')));
% resize if necessary
mosaic = dot_mosaic_gray(im, 52);  % Choose Size carefully!
figure; montage({im, mosaic});

% For grayscale dot mosaic
im = im2double(rgb2gray(imread('three.jpg')));
% resize if necessary
mosaic = dot_mosaic_gray(im, 60);  % Choose Size carefully!
figure; montage({im, mosaic});

% For color dot mosaic
im = im2double(imread('four.jpg'));
% resize if necessary
mosaic = dot_mosaic_color(im, 64);  % Choose Size carefully!
figure; montage({im, mosaic});

% For color dot mosaic
im = im2double(imread('five.jpg'));
% resize if necessary
mosaic = dot_mosaic_color(im, 60);  % Choose Size carefully!
figure; montage({im, mosaic});

% For color dot mosaic
im = im2double(imread('six.JPG'));
% resize if necessary
mosaic = dot_mosaic_color(im, 55);  % Choose Size carefully!
figure; montage({im, mosaic});


function result = dot_mosaic_gray(im, Size)
    [h, w] = size(im);
    k = max(1, floor(min(h, w)/Size));
    if mod(k, 2) == 0
        k = k - 1;
    end    
    h_two = floor(h/k);
    w_two = floor(w/k);
    sm = imresize(im, [h_two, w_two]);
    
    cells = cell(h_two, w_two);
    for i = 1:h_two
        for j = 1:w_two
            val = sm(i, j);
            sqr = ones(k, k);
            
            if val < .9
                rad = (1-val) * (k/2);
                rad = max(.5, min(rad, k/2-1));
                
                disk = 1 - fspecial('disk', rad) / max(max(fspecial('disk', rad)));
                [h_three, w_three] = size(disk);
                
                r_one = floor((k-h_three)/2)+1;
                c_one = floor((k-w_three)/2)+1;
                r_two = r_one + h_three - 1;
                c_two = c_one + w_three - 1;
                
                if r_two <= k && c_two <= k
                    sqr(r_one:r_two, c_one:c_two) = min(sqr(r_one:r_two, c_one:c_two), disk);
                end
            end
            cells{i,j} = sqr;
        end
    end
    result = cell2mat(cells);
end

function result = dot_mosaic_color(im, Size)
    r = dot_mosaic_gray(im(:, :, 1), Size);
    g = dot_mosaic_gray(im(:, :, 2), Size);
    b = dot_mosaic_gray(im(:, :, 3), Size);
    result = cat(3, r, g, b);
end
