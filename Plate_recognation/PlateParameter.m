function [cc,img,test]=PlateParameter(Text,binary_parameter)
global   ax2
ad=imadjust(Text);
binary=abs(1-im2bw(ad,binary_parameter));

%imshow(binary,'Parent',ax2)

%% reduce noice
noise=bwareaopen(binary,40);

% take off the border
noborder=imclearborder(noise,4);
imshow(noborder,'Parent',ax2)
%% filter size take just the 7 largest element the rest is noise
W=regionprops(noborder);
%% in the case that the border conected to the number try this:

% all object area size in arow
if ~isempty(W)
for obj=1:length(W)
    s(obj)=W(obj).Area;
end
noise7=maxi(s',8);

if length(noise7)==7
    noise8=noise7(end);
else
   noise8= noise7(end)+1;
end
% reduce noice agian 
cleanImage=bwareaopen(noborder,noise8);

imshow(cleanImage,'Parent',ax2)
img=cleanImage;
else
    %% cheak how much object ther is in the image
img=getimage(ax2);
end

imshow(img,'Parent',ax2)
%% check how much object  left in the image
cc = bwconncomp(img ,26);
W=regionprops(img);
test= Numcorrel(W);

end