function numberPlateExtraction1
%NUMBERPLATEEXTRACTION extracts the characters from the input number plate image.

f=imread('number.jpg');% Reading the number plate image.
f=imresize(f,[400 NaN]); % Resizing the image keeping aspect ratio same.
g=rgb2gray(f); % Converting the RGB (color) image to gray (intensity).
g=medfilt2(g,[3 3]); % Median filtering to remove noise.
se=strel('disk',1); % Structural element (disk of radius 1) for morphological processing.
gi=imdilate(g,se); % Dilating the gray image with the structural element.
ge=imerode(g,se); % Eroding the gray image with structural element.
gdiff=imsubtract(gi,ge); % Morphological Gradient for edges enhancement.
gdiff=mat2gray(gdiff); % Converting the class to double.
gdiff=conv2(gdiff,[1 1;1 1]); % Convolution of the double image for brightening the edges.
gdiff=imadjust(gdiff,[0.5 0.7],[0 1],0.1); % Intensity scaling between the range 0 to 1.
B=logical(gdiff); % Conversion of the class from double to binary. 
% Eliminating the possible horizontal lines from the output image of regiongrow
% that could be edges of license plate.
er=imerode(B,strel('line',50,0));
out1=imsubtract(B,er);
% Filling all the regions of the image.
F=imfill(out1,'holes');
% Thinning the image to ensure character isolation.
H=bwmorph(F,'thin',1);
H=imerode(H,strel('line',3,90));
% Selecting all the regions that are of pixel area more than 100.
final=bwareaopen(H,100);
% final=bwlabel(final); % Uncomment to make compitable with the previous versions of MATLAB®
% Two properties 'BoundingBox' and binary 'Image' corresponding to these
% Bounding boxes are acquired.
Iprops=regionprops(final,'BoundingBox','Image');
% Selecting all the bounding boxes in matrix of order numberofboxesX4;
NR=cat(1,Iprops.BoundingBox);
% Calling of controlling function.
r=controlling1(NR); % Function 'controlling' outputs the array of indices of boxes required for extraction of characters.
if ~isempty(r) % If succesfully indices of desired boxes are achieved.
    I={Iprops.Image}; % Cell array of 'Image' (one of the properties of regionprops)
    noPlate=[]; % Initializing the variable of number plate string.
    for v=1:length(r)
        N=I{1,r(v)}; % Extracting the binary image corresponding to the indices in 'r'.
        letter=readLetter1(N); % Reading the letter corresponding the binary image 'N'.
        while letter=='O' || letter=='0' % Since it wouldn't be easy to distinguish
           if v<=3                      % between '0' and 'O' during the extraction of character
         %      letter='O';              % in binary image. Using the characteristic of plates in Karachi
            else                         % that starting three characters are alphabets, this code will
          %      letter='0';              % easily decide whether it is '0' or 'O'. The condition for 'if'
            end                          % just need to be changed if the code is to be implemented with some other
            break;                       % cities plates. The condition should be changed accordingly.
        end
        noPlate=[noPlate letter];% Appending every subsequent character in noPlate variable.
    end
  %  in = noPlate;
%[num,txt,raw] = xlsread('noplate.xlsx');
%p = strcmpi(in,raw(:,2));% Compare user input string with entries in the Excel sheet
%rowNum = find(p==1)%Get Row number
%xlrange='A1';
%Index = find(contains(xlrange,'1R1ZHJ6336'));
%IndexA = strfind(A, '1R1ZHJ6336');
%data1=xlsread('noplate.xlsx','A1');

 %fid = fopen('no.txt', 'wt'); % This portion of code writes the number plate
  %  fprintf(fid,'%s\n',data1);      % to the text file, if executed a notepad file with the
   % fclose(fid);                      % name noPlate.txt will be open with the number plate written.
    %winopen('no.txt')
    %data1=xlsread('noplate.xlsx','A:A');
%data2=xlsread('noplate.xlsx','B:B');%
%data=data1];
%fprintf(data);
%[num, txt, raw] = xlsread('filename.xls',1,'C:C');
% A={'number'};
 %xlRange = 'A';
%num = xlsread('noplate.xlsx',1,'A1:A10') ;
%xlswrite('no.xslx',A,1,'A1:A10');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%in = '1H14DT8839';
in = noPlate;
[num,txt,raw] = xlsread('noplate.xlsx');
p = strcmpi(in,raw(:,1));% Compare user input string with entries in the Excel sheet
rowNum = find(p==1)%Get Row number
x=num2str(rowNum);
a='A';
b='B';
c='C';
d='D';
xlrange=strcat(a,x);
xlrange1=strcat(b,x);
xlrange2=strcat(c,x);
xlrange3=strcat(d,x);
fprintf(xlrange);
fprintf(xlrange1);
fprintf(xlrange2);
fprintf(xlrange3);
range='A1';
range1='B1';
range2='C1';
range3='D1';
%xlsread(filename,sheet,xlRange)
%num = xlsread('noplate.xlsx',1,xlrange);
[~, text]= xlsread('noplate.xlsx',1,xlrange);
xlswrite('no.xlsx',text,1,range);
[~,text1]= xlsread('noplate.xlsx',1,xlrange1);
xlswrite('no.xlsx',text1,1,range1);
text2= xlsread('noplate.xlsx',1,xlrange2);
xlswrite('no.xlsx',text2,1,range2);
%NumDays = daysact(text2,datestr(now,24));
%d1=datestr(now,24);
%fprintf(datestr(now,24));
%d2=text2;
%fprintf(int2str(text2));

a  =[text1;datestr(now,'yyyymmdd HHMMSS')];  % two dates apart 1hr 1min
  d=datenum(a,'yyyymmdd HHMMSS');          % convert to number
  difference=d(2)-d(1);                  % difference between the two
 b =datestr(difference,'HH:MM:SS')% difference in hr:min:sec
 a1=datestr(now);
b1=(str2num(b(1)));
b2=(str2num(b(2)));
b3=b1*10;
b4=b2*1;
b5=b3+b4
dateis=xlsread('noplate.xlsx',1,xlrange1);
%fprintf('exit time and date is=%s\n',int2str(dateis));
fprintf('exit time and date is=%s\n',a1);
if b5<1
    fprintf('cost is=5');
else
    fprintf('cost is=%d',(b5*5));
end
num='o';
num1='C';

xlrange4=strcat(num1,x);
loc=xlsread('noplate.xlsx',1,xlrange4);
fprintf('loc is=%d',loc);
loc1=num2str(loc);
in = '1';
[num,txt,raw] = xlsread('slot.xlsx');
p = strcmpi(in,raw(:,1));% Compare user input string with entries in the Excel sheet
rowNum=find(p==1)%Get Row number
x1=int2str(rowNum);
a1='A';
xlrange5=strcat(a1,x1);

xlswrite('slot.xlsx',num,1,xlrange5);


%fprintf('%d',b2);
%fprintf(num2str(b2));
%fprintf(num2str(b3));
%[~, text3]= xlsread('noplate.xlsx',1,xlrange3);
%xlswrite('no.xlsx',text3,1,range3);
%data = xlsread('noplate.xlsx',1,xlrange);
%xlsread(filename,sheet,xlRange)
%num = xlsread('noplate.xlsx',1,xlrange);
%num1= xlsread('noplate.xlsx',1,('A':x));%:('D':xlrange));
%xlswrite('no.xlsx',data,1,a);
%readdata=[text];
%fid = fopen('no.txt', 'wt'); % This portion of code writes the number plate
 %   fprintf(fid,'%s\n',num2str(num));      % to the text file, if executed a notepad file with the
  % fclose(fid);                      % name noPlate.txt will be open with the number plate written.
   % winopen('no.txt')
    %datetime;
    %t = datetime(2018,1,1);
    %dt = t - datetime(2018,2,1);
    %x = hours(dt);
    



    fid = fopen('noPlate.txt', 'wt'); % This portion of code writes the number plate
    fprintf(fid,'%s\n',noPlate);      % to the text file, if executed a notepad file with the
    fclose(fid);                      % name noPlate.txt will be open with the number plate written.
    winopen('noPlate.txt')
    
%     Uncomment the portion of code below if Database is  to be organized. Since my
%     project requires database so I have written this code. DB is the .mat
%     file containing the array of structure of all entries of database.
 %    load DB
  %   for x=1:length(DB)
   %      recordplate=getfield(DB,{1,x},'PlateNumber');
    %     if strcmp(noPlate,recordplate)
     %        disp(DB(x));
      %       disp('*-*-*-*-*-*-*');
       %  end
     %end
    
else % If fail to extract the indexes in 'r' this line of error will be displayed.
    fprintf('Unable to extract the characters from the number plate.\n');
    fprintf('The characters on the number plate might not be clear or touching with each other or boundries.\n');
end
end
