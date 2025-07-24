function [EvaLum,Greyout]= GrayAnchorV4(img,mask)

img = double(img);
R=img(:,:,1);
G=img(:,:,2);
B=img(:,:,3);
Y=0.5*(img(:,:,1)+img(:,:,2));

R(R==0)=eps; G(G==0)=eps;
B(B==0)=eps; Y(Y==0)=eps;

% log  
logR = log(R); logG = log(G); 
logB = log(B); logY = log(Y); 

Surround = fspecial('gaussian',[15 15],5);
Dr = logR - imfilter(logR,Surround,'conv','replicate');
Dg = logG - imfilter(logG,Surround,'conv','replicate');
Db = logB - imfilter(logB,Surround,'conv','replicate');
Dy = logY - imfilter(logY,Surround,'conv','replicate');

DOrg = Dr-Dg;
DOby = Db-Dy;
Greyidx = sqrt((DOrg).^2+(DOby).^2);

Greyidx(abs(Dr)<0.0001 & abs(Dg)<0.0001 & abs(Db)<0.0001 & abs(Dy)<0.0001)= max(Greyidx(:));
Greyidx(mask==1) = max(Greyidx(:));

Greyout = Greyidx;

%=========================V4============================%
normimg = img./max(img(:));
Rn=normimg(:,:,1); Gn=normimg(:,:,2); Bn=normimg(:,:,3);  % Hue Response

RR = Rn; 
GG = Gn; 
BB = Bn;
Greyidx=5*(1./(1+exp(-30*Greyidx))-0.5);
Ri = max(0,RR-Greyidx.*RR);
Gi = max(0,GG-Greyidx.*GG);
Bi = max(0,BB-Greyidx.*BB);

if ~isempty(mask)
    Ri(find(mask)) = [];
    Gi(find(mask)) = [];
    Bi(find(mask)) = [];
end

Rillu = sum(Ri(:));
Gillu = sum(Gi(:));
Billu = sum(Bi(:));

EvaLum =[Rillu Gillu Billu];
EvaLum = EvaLum / sqrt(sum(EvaLum.^2));

