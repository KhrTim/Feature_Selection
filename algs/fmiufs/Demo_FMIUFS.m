
load Example

trandata=Example;
trandata(:,3:4)=normalize(trandata(:,3:4));
lammda=1; 
feature_seq=FMIUFS(trandata,lammda)


