function derivatives=compute_derivatives(dns,field)

M=zeros(5,5); t=zeros(5,1);
derivatives.d1=zeros(dns.ny+3,5); derivatives.d2=derivatives.d1;

for IY=-1:dns.ny+1
    % define helping indices
    iy=IY+2; shift=(2-IY)*(IY<1) + (dns.ny-1-IY)*(IY>(dns.ny-1));
    % d1
    for i=0:4; for j=0:4; M(i+1,j+1)=(field.y(iy-2+j+shift)-field.y(iy))^(4-i); end; end
    t=t*0; t(4)=1; derivatives.d1(iy,1:5)=(M\t)';
    % d2
    for i=0:4; for j=0:4; M(i+1,j+1)=(field.y(iy-2+j+shift)-field.y(iy))^(4-i); end; end
    t=t*0; t(3)=2; derivatives.d2(iy,1:5)=(M\t)';
end
