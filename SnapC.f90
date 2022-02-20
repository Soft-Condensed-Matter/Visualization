!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!%%**  PROGRAM    POV-RAY SNAPSHOT                                         **%%
!%%**  AUTHOR     ALEXIS TORRES CARBAJAL                                   **%%
!%%**  LICENSE    LGPL-V3                                                  **%%
!%%**  DATE       NOVEMBER 6, 2020                                         **%%
!%%**                                                                      **%%
!%%**  OBS        THIS PROGRAM CREATES A FILE Snapshot.pov TO BE USED IN   **%%
!%%**             POV-RAY TO MAKE A SNAPSHOT WITH MOLECULES' POSITIOS.     **%%
!%%**             IT USES THE FILE MDFin.dat WHICH IN THE FIRST THREE      **%%
!%%**             COLUMNS CONTAINS THE CARTESIAN XYZ COMPONENTS            **%%
!%%**             IT IS NECESSARY TO SPECIFIED THE NUMBER OF PARTICLES AND **%%
!%%**             PACKING FRACTION IN ORDER TO DRAW THE SIMULATION BOX.    **%%
!%%**             THE DEFAULT MOLECULE DIAMETER IS 1 AND DISTANCE ARE      **%%
!%%**             MEASURED WITH SUCH UNIT LENGHT                           **%%
!%%**             THE SNAPSHOT IS RENDERED AS:                             **%%
!%%**             $ povray -D +w1920 +h1080 Snapshot.pov                   **%%
!%%**                                                                      **%%
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MODULE POVAR
 INTEGER, PARAMETER:: D      = KIND(1.0D0)  !PROGRAM PRECISION
 INTEGER, PARAMETER:: NPARTX = 100000       !MAXIMUM NUMBER OF PARTICLES
 INTEGER, PARAMETER:: NSAMP  = 2000         !MAXIMUM NUMBER OF SAMPLES
 
 REAL(D), PARAMETER:: SIGMA  = 1.0D0        !MOLECULES DIAMETER
 REAL(D), PARAMETER:: SIGMAC = 10.0D0       !COLLOID  DIAMETER
 REAL(D), PARAMETER:: PI     = DACOS(-1.0D0)!PI NUMBER

 CHARACTER*10:: CDUMMY

 INTEGER:: NP,ISAM,DUMMY                    !NUMBER OF PARTICLES
 REAL(D):: RHOSTAR,PHI,BOXX,RC,L            !DENSITY AND PACKING FRACTION
 REAL(D):: RX(NPARTX),RY(NPARTX),RZ(NPARTX) !X,Y,Z COORDINATES
END MODULE POVAR
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%   MAIN PROGRAM   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PROGRAM SNAPSHOT
 USE POVAR

 OPEN(UNIT=10,FILE='IConf.xyz',STATUS='OLD')
 OPEN(UNIT=11,FILE='Snapshot.pov',STATUS='UNKNOWN')

 READ(10,*)NP
 READ(10,*)CDUMMY,DUMMY

 RHOSTAR=0.80                               !DENSITY NUMBER
 BOXX=DSQRT(DBLE(NP)/RHOSTAR) + 0.2D0
 RC=0.5D0*BOXX
 L=RC + 1.D0*SIGMA

 DO I=1,NP
    READ(10,*)CDUMMY,RX(I),RY(I),RZ(I)      !READ DATA FROM FILE
 ENDDO

 CALL PICTURE                               !CREATE POV FILE
 
 CLOSE(UNIT=10) 
 CLOSE(UNIT=11) 

 STOP
END PROGRAM SNAPSHOT
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%   SUBROUTINES   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SUBROUTINE PICTURE
 USE POVAR  

!LIGHT SOURCE AND CAMERA POSITION
 WRITE(11,*) '#include "colors.inc" '
 WRITE(11,*) "background {White}"
 WRITE(11,*) "camera{"
 WRITE(11,*) "location <",0.0,",",0.0,",",-0.1*BOXX,">"
 WRITE(11,*) "look_at <0, 0, 0>"
 WRITE(11,*) "angle 70}"
 WRITE(11,*) "light_source { <0, 25, 20> color White }"
 WRITE(11,*) "light_source { <0, -25, -20> color White }"
 WRITE(11,*) "light_source { <25, 0, 20> color White }"
 WRITE(11,*) "light_source { <-25, 0, -20> color White }"
 WRITE(11,*) "light_source { <25, 0, 0> color White }"
 WRITE(11,*) "light_source { <-25, 0, 0> color White }"
 WRITE(11,*) "light_source { <0, 25, 0> color White }"
 WRITE(11,*) "light_source { <0, -25, 0> color White }"

!SIMULATION BOX
 WRITE(11,10003) -1.d0*L,-1.d0*L,0.d0*L,L,-1.d0*L,0.d0*L
 WRITE(11,10003) -1.d0*L,1.d0*L,0.d0*L,L,1.d0*L,0.d0*L

 WRITE(11,10003) -1.d0*L,-1.d0*L,0.d0*L,-1.d0*L,1.d0*L,0.d0*L
 WRITE(11,10003) 1.d0*L,-1.d0*L,0.d0*L,1.d0*L,1.d0*L,0.d0*L


 DO I=1,NP
    IF(I .LE. NP-1)THEN
      WRITE(11,10001)RX(I),RY(I),RZ(I),SIGMA/2.0D0
    ELSE
      WRITE(11,10002)RX(I),RY(I),RZ(I),SIGMAC/2.0D0
    ENDIF
 ENDDO

 CLOSE(UNIT=11)

!GREEN
10000  FORMAT("sphere{<",F9.4,",",F9.4,",",F9.4,">,",F8.5, &
       "pigment{color red 0.1 blue 0.1 green 0.85} finish &
       {phong .05 reflection {.1}}}")
!BLUE
10001  FORMAT("sphere{<",F9.4,",",F9.4,",",F9.4,">,",F8.5, &
       "pigment{color red 0.1 blue 0.85 green 0.1} finish &
       {phong .05 reflection {.01}}}")
!RED
10002  FORMAT("sphere{<",F9.4,",",F9.4,",",F9.4,">,",F8.5, &
       "pigment{color red 0.85 blue 0.1 green 0.1} finish &
       {phong .05 reflection {.1}}}")
!CYLINDER YELLOW
10004  FORMAT("sphere{<",F9.4,",",F9.4,",",F9.4,">,",F8.5, &
       "pigment{color Yellow } finish {phong .05 reflection {.1}}}")
!CYLINDER GREY
10003  FORMAT("cylinder{ <",F9.4,",",F9.4,",",F9.4,">, &
       <",F9.4,",",F9.4,",",F9.4,">, 1.0 pigment { color &
       rgbf <0.4,0.4,0.4,.0> } finish{  brilliance 1 phong &
       1 phong_size 380  metallic reflection 0.05 } }")

 RETURN
END SUBROUTINE PICTURE
