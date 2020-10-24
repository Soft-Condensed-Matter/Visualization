!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!%%**  PROGRAM    MOVIE MD                                                 **%%
!%%**  AUTHOR     ALEXIS TORRES CARBAJAL                                   **%%
!%%**  LICENSE    LGPL-V3                                                  **%%
!%%**  DATE       OCTOBER 23, 2020                                         **%%
!%%**                                                                      **%%
!%%**  OBS        THIS PROGRAM CREATES A FILE MDFilm.xyz FOR VMD TO MAKE   **%%
!%%**             A SIMPLE ANIMATION WITH VMD. IT USES THE FILE MDPos.dat  **%%
!%%**             WHICH CONTAINS THE CARTESIAN COORDINATES OF THE MOLECULES**%%
!%%**             POSITIONS AT DIFFERENT INTERVALS CALLED SAMPLES.         **%%
!%%**             THE DEFAULT MOLECULE USED IS CARBON 'C'                  **%%
!%%**                                                                      **%%
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PROGRAM MOVIEMD
 INTEGER, PARAMETER:: D      = KIND (1.0D0) !NUMBER PRECISION
 INTEGER, PARAMETER:: NPARTX = 10000        !MAXIMUN NUMBER OF PARTICLES
 INTEGER:: I,NPART,NSAMP,IFRAME
 REAL(D):: RX(NPARTX),RY(NPARTX),RZ(NPARTX)
 
 OPEN(UNIT=10,FILE='MDPos.dat',STATUS='OLD')!INPUT FILE
 OPEN(UNIT=11,FILE='MDFilm.xyz')            !OUTPUT FILE

 NPART=2048                                 !NUMBER OF PARTICLES
 NSAMP=9001                                 !NUMBER OF SAMPLES

 DO J=1,NSAMP
    READ(10,*)IFRAME

    WRITE(11,*)NPART 
    WRITE(11,*)'FRAME',IFRAME
    DO I=1,NPART
       READ(10,*)RX(I),RY(I),RZ(I)

       WRITE(11,*)'C',RX(I),RY(I),RZ(I)
    ENDDO
 ENDDO

 STOP
END PROGRAM MOVIEMD
