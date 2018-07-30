function dns=read_header(filename)

f=fopen(filename);
dns.nx=fread(f,1,'uint16');
fseek(f,2,'cof');
dns.ny=fread(f,1,'uint16');
fseek(f,2,'cof');
dns.nz=fread(f,1,'uint16');
fseek(f,2,'cof');
dns.alfa0=fread(f,1,'double');
dns.beta0=fread(f,1,'double');
dns.ni=fread(f,1,'double');
dns.a=fread(f,1,'double');
dns.ymin=fread(f,1,'double');
dns.ymax=fread(f,1,'double');
dns.time=fread(f,1,'double');
fclose(f);

end