


% -------------------------------------------------------------------
clc
clear variables
addpath('./base/');

% -------------------------------------------------------------------
[dns]=read_header('Dati.cart.out');
[dns,field]=init(dns);
[derivatives]=compute_derivatives(dns,field);

return

% -------------------------------------------------------------------
numlabs=8; IX0=zeros(numlabs,1); IXN=IX0; NXB=IX0;
for i=1:numlabs
   IX0(i)=(i-1)*floor((dns.nx+1)/numlabs)+1; IXN(i)=i*floor((dns.nx+1)/numlabs); NXB(i)=IXN(i)-IX0(i)+1;
end

% -------------------------------------------------------------------
spmd(numlabs)
   % Index of the codistributed arrray
   ix0=IX0(labindex); ixn=IXN(labindex); nxb=NXB(labindex);
   prev = labindex-1; next = labindex+1;
   % Build velocity vector
   V=complex(zeros([dns.ny+3,2*dns.nz+1,nxb,3]),0);
   % Codistribute it
   field.V=codistributed.build(V, codistributor1d(3,NXB',[dns.ny+3,2*dns.nz+1,dns.nx+1,3])); V=[];
   % Read field file
   field.f=fopen('Dati.cart.out');
   for iV=1:3
   for ix=ix0:ixn; IX=ix-1;
    fseek(field.f, ... 
          4*3+8*7 +8*2*( ...
          +(iV-1)*((dns.ny+3)*(2*dns.nz+1)*(dns.nx+1)) ...
          +(IX)*((dns.ny+3)*(2*dns.nz+1)) ...
          ),'bof');
    V=reshape(fread(field.f,2*(dns.ny+3)*(2*dns.nz+1),'double'),[2,dns.ny+3,2*dns.nz+1,1,1]); 
    field.V(:,:,ix,iV)=reshape(complex(V(1,:,:,:,:),V(2,:,:,:,:)),[dns.ny+3,2*dns.nz+1,1,1]);
   end
   end
   fclose(field.f);
   % Compute 3D spectrum
   field.psd=zeros([dns.ny/2+1,dns.nz+1,dns.nx+1,4],codistributor1d(3,NXB',[dns.ny/2+2,dns.nz+1,dns.nx+1,4]));
   field.psd(:,:,ix0:ixn,4) = real(  0.25*field.V(2:dns.ny/2+2,dns.nz+1:end,ix0:ixn,2).*field.V(2:dns.ny/2+2,dns.nz+1:end,ix0:ixn,1) ...
                                   - 0.25*field.V(dns.ny+2:-1:dns.ny/2+2,dns.nz+1:end,ix0:ixn,2).*field.V(dns.ny+2:-1:dns.ny/2+2,dns.nz+1:end,ix0:ixn,1)...
                                   + 0.25*field.V(2:dns.ny/2+2,dns.nz+1:-1:1,ix0:ixn,2).*field.V(2:dns.ny/2+2,dns.nz+1:-1:1,ix0:ixn,1) ...
                                   - 0.25*field.V(dns.ny+2:-1:dns.ny/2+2,dns.nz+1:-1:1,ix0:ixn,2).*field.V(dns.ny+2:-1:dns.ny/2+2,dns.nz+1:-1:1,ix0:ixn,1)...
                                  );
end

