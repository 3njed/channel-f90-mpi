function [dns,field]=init(dns)

% Define y-coordinates
field.y=zeros(dns.ny+3,1);
for i=1:dns.ny+3
    field.y(i)=dns.ymin+0.5*(dns.ymax-dns.ymin)* ...
               (tanh(dns.a*(2*(i-2)/dns.ny-1))/tanh(dns.a)...
               +0.5*(dns.ymax-dns.ymin));
end

% Compute extended number of modes
dns.nxd=3*dns.nx/2; while ~fftfit(dns.nxd); dns.nxd=dns.nxd+1; end   
dns.nzd=3*dns.nz;   while ~fftfit(dns.nzd); dns.nzd=dns.nzd+1; end

end