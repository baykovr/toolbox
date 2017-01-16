ScholarPuller
=============

Command line tool for simple Google Scholar quiries, outputs  the first .pdf url result.

Example

    python2 sp.py -t "fresco software defined networking"             
    http://www.csl.sri.com/users/vinod/papers/fresco.pdf

You can couple it with wget to download pdf's much faster than using a browser:

    wget $(python2 sp.py -t "fresco software defined networking")
      fresco.pdf    100%[=======================================>] 797.04K   993KB/s   in 0.8s
     ‘fresco.pdf’ saved [816167/816167]
