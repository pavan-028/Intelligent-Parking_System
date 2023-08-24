function [RgbPlat]=LocatPlat(RGBimage,NumColor)
global  ax1 ax2
%%
RgbPlat=[];
plat=RGBimage;
%imshow(plat,'Parent',ax1)

%%
 [X_no_dither,map]= rgb2ind(plat,NumColor,'nodither');
 %imshow(X_no_dither,map,'Parent',ax1)
 %% rgb  yellow filter
 r=map(:,1)>0.5;
 g=map(:,2)>0.3;
 b=map(:,3)<0.31;
 

 
 y=r.*g.*b;
 
 
 locy=find(y);
 
 by=roicolor(X_no_dither, locy-1);
 
 %imshow(by,'Parent',ax1)
 
  %% noise filter
noise1=bwareaopen(by,200);
%imshow(noise1,'Parent',ax1)



 
   cc = bwconncomp(noise1, 26);
if cc.NumObjects==0
    return
end
 %%
SE = strel('square',7);
 yellow=imdilate(by ,SE);
 RGBfill=imfill(yellow,'holes');
%imshow(RGBfill,'Parent',ax1)

 %% noise filter
 

 rgb=bwareaopen(RGBfill,2000);
%imshow(rgb,'Parent',ax1)

%% shape filter

%%
 
  SE = strel('square',1);
 yellow=imdilate(rgb ,SE);
yellowclear=yellow;
% yellowclear=imclearborder(yellow);

%imshow(yellowclear,'Parent',ax1)

%%
  W=regionprops(yellowclear);
   cc = bwconncomp(yellowclear, 26);
   
  %%
 

NumberObj=size(W);
box=cell(1,NumberObj(1));

for n=1:NumberObj(1)
    
    box{n}.width=W(n).BoundingBox(3);
    box{n}.high=W(n).BoundingBox(4);
    box{n}.z=box{n}.width/box{n}.high;
     
end
%% Test - the higth/Width proportion test

word  = false(size(yellow));
 for n=1:cc.NumObjects
allowed=box{n}.z>1.67&&box{n}.z<6.7;
word(cc.PixelIdxList{n}) = allowed;
hold on; 
imshow(word,'Parent',ax1)
 
 end
 
 %%  delete the image thet are smaller to see the number
 noise2=bwareaopen(word,4300);

imshow(noise2,'Parent',ax1)
%%
 imgplat=getimage(ax1);
 cc = bwconncomp(imgplat, 26);
 W=regionprops(imgplat);
 
 %% test the fill Area Test
 
 
 %% the biggest size Test
 if cc. NumObjects>1
     
            word  = false(size(yellow));
            areas=[W.Area];
            Sper=zeros(1,cc.NumObjects);
            for n=1:cc.NumObjects
             Sper(n)=  W(n).Area/(W(n).BoundingBox(3)*W(n).BoundingBox(4));
            end
            if abs(min(Sper)-max(Sper))>0.07
                                    for n=1:cc.NumObjects
                                            allowed=Sper(n)==max(Sper);
                                            word(cc.PixelIdxList{n}) = allowed;
                                            hold on; 
                                            imshow(word,'Parent',ax1)

                                    end
            else
                                    for n=1:cc.NumObjects
                                                    allowed=W(n).Area==max(areas);
                                                    word(cc.PixelIdxList{n}) = allowed;
                                                  hold on; 
                                               imshow(word,'Parent',ax1)
                                    end
            end

 elseif cc. NumObjects==0

     return
 
 end
 %%
img=getimage(ax1);
W=regionprops(img);
rect=W.BoundingBox;
rect=rect+[0 -15 -5 15];
RgbPlat=imcrop(plat,rect);
 imshow(RgbPlat,'Parent',ax2)    %put % here for beter prefrmence
 pause(1)    %put % here for beter prefrmence 
end
 