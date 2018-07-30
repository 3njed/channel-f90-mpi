function df=deriv(f,der,dns)

df = zeros(size(f));
for IY=-1:dns.ny+1 
    iy=IY+2; shift=(2-IY)*(IY<1) + (dns.ny-1-IY)*(IY>(dns.ny-1));
    df(iy,:) = sum(repmat(reshape(der(iy,:),[5,1]),size(f(1,:))).*f(iy+shift+(-2:2),:));
end
