function [sub] =mini(matrix,num)

SortMat=sort(matrix,'ascend');

sub=wkeep(SortMat,[num length(SortMat)],'l' );



end