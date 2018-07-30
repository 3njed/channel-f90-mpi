      V=0
      IF (has_terminal) WRITE(*,*) "Generating initial field..."
      DO iy=-1,ny+1; DO ix=nx0,nxN; DO iz=-nz,nz
   !       V(iy,iz,ix,1) = 0.0001*EXP(dcmplx(0,RAND()-0.5));  V(iy,iz,ix,2) = 0.0001*EXP(dcmplx(0,RAND()-0.5));  V(iy,iz,ix,3) = 0.0001*EXP(dcmplx(0,RAND()-0.5));
      END DO;        END DO;        END DO
      IF (has_terminal) THEN
        DO CONCURRENT (iy=-1:ny+1)
          V(iy,0,0,1)=y(iy)*(2-y(iy))*3.d0/2.d0 + 0.001*SIN(8*y(iy)*2*PI);
        END DO
      END IF
