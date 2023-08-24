function [display_plat]= Recar
close all;
global ax1 ax2 fig1 fig2
[FileName] = uigetfile({'*.jpg;*.png; *.bmp'},'Select the RGB image');
if  FileName==0
    display_plat=[];
    return
end

car=imread(FileName);
load('PL.mat','LN')

% profile on
            fig1=figure...
                ('number','off','name','Test Image','unit','normalized'...
                ,'WindowStyle','docked','renderer','opengl');
             ax1=axes('Parent',fig1);
imshow(car,'Parent',ax1)
            fig2=figure...
                ('number','off','name','Plate Number','unit','normalized'...
                ,'WindowStyle','docked','renderer','opengl');
             ax2=axes('Parent',fig2);
pause(4)
profile on
tic
%% crop image
try
 
 NumColor=10;
    Pateimage=[];



   pow=1;
while (isempty(Pateimage))
   pow=pow+1;
    NumColor=NumColor+2^(pow);
    if NumColor>128
        break
    else
      [Pateimage]=LocatPlat(car,NumColor);    
    end
end
   

%% zoom on the plate number

Text=rgb2gray(Pateimage);

%imshow(Text)
par=0.13;
[cc,img,test]=PlateParameter(Text,par);

while ((cc.NumObjects<7)||(test==0))
   
    par=par+0.105;
    if par>0.8650
        break
    else
    [cc,img,test]=PlateParameter(Text,par);     
    end
end


W=regionprops(img);



 %%
 
 
sizew=size(W);
box_area=cell(1,sizew(1));
area=zeros(1,sizew(1));

for num_element=1:sizew
    
box_area{1,num_element}=W(num_element).BoundingBox;

rectangle('parent',ax2,'Position',[box_area{1,num_element}] ,'edgecolor','g')
width= box_area{1,num_element}(3);
higth=box_area{1,num_element}(4);
area(num_element)=width*higth;

end

%% crop every numbere from the left to the rigth
L=cell(1,7);
Lresize=cell(1,7);
Lfill=cell(1,7);
for num=1:7
L{1,num}=imcrop(img,box_area{1,num});
Lresize{1,num}=imresize(L{1,num},  size(LN{1}));
Lfill{1,num}=imfill(Lresize{1,num},'holes');

end

%% check the correlation between the plate number
%and the save number

detect_num=cell(7,10);
for n=1:7
    for p=1:10
detect_num{n,p}=corr2(Lresize{1,n},LN{p}); 
    end
end
%%
bigger=zeros(7,10);

for p=1:10
    for n=1:7
        
bigger(n,p)=sum(detect_num{n,p}(:),[],'double');
    end
end

%% plat_number
 plat_number=zeros(1,10);
%% if the numbet is the biggest in the array so this is the number!
for n=1:10
    for p=1:10
    
   if  bigger(n,p)==max(bigger(n,:))
   
break
   end
  
    end
    if p==10
        p=0;
    end   
    plat_number(n)=p;

end


%%
display_plat=[num2str(plat_number(1)) num2str(plat_number(2))  num2str(plat_number(3)) num2str(plat_number(4)) num2str(plat_number(5)) num2str(plat_number(6)) num2str(plat_number(7)) num2str(plat_number(8)),num2str(plat_number(9)),num2str(plat_number(10))];
disp(display_plat);

%% The End.
catch  err
    err.message  
    disp('Erorr coudnt locat the plate number of the car  image')
end


profile off
%profile viewer
toc
end
