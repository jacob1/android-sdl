sources:=  apiplan.c configure.c execute.c  malloc.c mapflags.c mktensor-rowmajor.c plan-dft-r2c.c plan-dft-r2c-2d.c plan-many-dft-r2c.c plan-dft-c2r.c plan-dft-c2r-2d.c plan-many-dft-c2r.c rdft2-pad.c  the-planner.c

LOCAL_SRC_FILES += $(addprefix api/, $(sources))
