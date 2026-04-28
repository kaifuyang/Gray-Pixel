function [EvaLum,Greyout] = GrayAnchoring(img,mask)

img = double(img);
img = img./max(img(:));
R=img(:,:,1);
G=img(:,:,2);
B=img(:,:,3);
Y=0.5*(img(:,:,1)+img(:,:,2));

R(R<=eps)=eps; G(G<=eps)=eps;
B(B<=eps)=eps; Y(Y<=eps)=eps;

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

hh = fspecial('average',[7 7]);
Greyidx = imfilter(Greyidx,hh,'circular');

% Post-Processing
Greyidx(abs(Dr)<0.0001 | abs(Dg)<0.0001 | abs(Db)<0.0001 | abs(Dy)<0.0001)= max(Greyidx(:));
Greyidx(mask==1) = max(Greyidx(:));

Greyidx = (Greyidx-min(Greyidx(:)))/(max(Greyidx(:))-min(Greyidx(:)));
Greyout = Greyidx;

%=========================V4============================%
% Illuminant Estimation
RR=img(:,:,1); GG=img(:,:,2); BB=img(:,:,3);  % Hue Response

Amax=10; n=1.1; sig=0.005;
Gidx = Amax * Greyidx.^n./(Greyidx.^n+sig.^n);

Ri = max(0,RR-Gidx.*RR);
Gi = max(0,GG-Gidx.*GG);
Bi = max(0,BB-Gidx.*BB);
if ~isempty(mask)
    Ri(find(mask)) = []; Gi(find(mask)) = []; Bi(find(mask)) = [];
end

Rillu = sum(Ri(:)); Gillu = sum(Gi(:)); Billu = sum(Bi(:));
EvaLum =[Rillu Gillu Billu];
EvaLum = EvaLum / sqrt(sum(EvaLum.^2));


            


