function [sub] =maxi(matrix,num)

SortMat=sort(matrix,'descend');
sub=wkeep(SortMat,[num length(SortMat)],'l' );
end