Codes to facilitate the visualization of data from computer simulations or experiments.

The codes are mainly developed in FORTRAN, contributions in other languages are welcome.


Code: MovieMD.f90

Description: Creates a file *.xyz to use in vmd for a simple movie. 
It uses a *.dat file with the coordinates of the particles

Code: Snap.f90
Description: Creates a snapshot from molecules' coordinates using povray
It uses a *.dat file with the coordinates of the particles
$ povray -D +w 1920 +h1080 Snapshot.pov
