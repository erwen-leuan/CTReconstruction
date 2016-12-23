close all;
N=size(F1,1);
M=size(F1,2);
DetectorWidth=N;
r_spacing=445.059/DetectorWidth;
% r_spacing=0.1;
nx=512;
ny=nx;
cutoff=0.3;
smooth=0.5;
DetectorSize=r_spacing*DetectorWidth;
R=1000;
D=500;
r_max=floor(N/2)*r_spacing;
% gamma=-r_max:r_spacing:r_max;
% gamma=linspace(-r_max,r_max,DetectorWidth);
gamma=(1:N)-(N-1)/2;
gamma=gamma*r_spacing;
gamma=gamma*R./(D+R);
% gamma=((1:DetectorWidth)-(DetectorWidth-1)/2)*r_spacing;
ZeroPaddedLength=2^ceil(log2(2*(N-1)));
% if(mod(N,2)==0)
%     h=FilterLine(ZeroPaddedLength+1,r_spacing*(R/(R+D)),cutoff,smooth);
%     h=h(1:end-1);
% else
%     h=FilterLine(N,r_spacing*(R/(R+D)),cutoff,smooth);
% end
deltaS=r_spacing*R/(R+D);
h=FilterLine(ZeroPaddedLength+1,r_spacing,cutoff,smooth);
h=h(1:end-1);
% h=circshift(h,[0 -ZeroPaddedLength/2]);
fov=2*R*sin(atan(DetectorSize/2/(D+R)));
PointSpacing=fov/nx;
x=linspace(-fov/2,fov/2,nx);
% x=((0:nx-1)-(nx-1)/2)*PointSpacing;
y=linspace(-fov/2,fov/2,nx);
% y=((0:ny-1)-(ny-1)/2)*PointSpacing;
filter=abs(fftshift(fft(h)));
filter=filter';
[X,Y]=meshgrid(x,y);
recon=zeros(nx,ny);
[phi,r]=cart2pol(X,Y);
theta=linspace(0,360,M+1);
theta=theta*(pi/180);
dtheta=(pi*2)/M;
% ZeroPaddedProjection=zeros(ZeroPaddedLength,1);

for i=1:M
    R1=F1(:,i);
    w=(R./sqrt(R^2+gamma'.^2));
    R2=w.*R1;
%     ZeroPaddedProjection(1:length(R2))=R2;
%     R2=(D)*R.*(1./sqrt(D^2+gamma'.^2));
    Q=real(ifft(ifftshift(fftshift(fft(R2,ZeroPaddedLength)).*filter)));
    Q=Q(1:length(R2));
    angle=theta(i);
    t=X.*cos(angle)+Y.*sin(angle);
    s=-X.*sin(angle)+Y.*cos(angle);
    InterpX=(R.*t)./(R-s);
%     fprintf('%f %f\n',max(InterpX(:)),min(InterpX(:)));
    U=(((R)+r.*sin(angle-phi))./(R));
    U=U/deltaS;
%     U=(R^2)./(R-s).^2;
    %     imshow(U,[]);
%     InterpX=InterpX/deltaS;
    vq=interp1(gamma,Q,InterpX,'linear',0);
%     vq=interp2(p,ki,Q,InterpY,InterpX,'spline',0);
%     recon(ii)=recon(ii)+dtheta.*(1./(U.^2)).*vq;
    recon=recon+dtheta.*(1./(U.^2)).*vq;
%     imshow(recon,[]);
end
CompareFanRecon;