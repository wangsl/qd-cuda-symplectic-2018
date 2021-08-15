
# $Id$

.DEFAULT: .F .F90 .c .C
.SUFFIXES: .F .F90 .c .C

SRC = $(PWD)
O = $(SRC)/../../build/HO2

F77 = gfortran
F90 = gfortran
CC = gcc
CXX = g++

CFLAGS = -O3 -fopenmp -fPIC 

FFLAGS = -O3 -fPIC -fopenmp -ffixed-line-length-132

CXXFLAGS = -O3 -fopenmp -fPIC -std=c++11 -I$(MATLAB_ROOT)/extern/include \
	-I$(SRC)/../common-cuda 

Link = $(CXX)

LIBS = -L$(SRC)/../../build/common-cuda -L$(SRC)/../../build/common-hip -lqmdyn -lgfortran

MEXA64Files = $(O)/DMBEIVMex.mexa64

OBJS = 	$(O)/dmbeiv.o $(O)/DMBEIVMex.o


.DEFAULT_GOAL := $(O)/DMBEIVMex.mexa64

all: $(MEXA64Files)

$(O)/%.o: %.c
	cd $(O) ; $(CC)  $(cFLAGS) -c $(SRC)/$<
$(O)/%.o: %.C
	cd $(O) ; $(CXX) $(CXXFLAGS) -c $(SRC)/$<
$(O)/%.o: %.F
	cd $(O) ; $(F77) $(FFLAGS) -c $(SRC)/$<
$(O)/%.o: %.F90
	cd $(O) ; $(F90) $(FFLAGS) -c $(SRC)/$<
$(O)/%.o: %.cu
	cd $(O) ; $(NVCC) $(NVCCFLAGS) -dc $(SRC)/$<

%io.C: %.h
	perl io.pl $<

$(O)/%.mexa64: $(OBJS)
	cd $(O); $(Link) -shared $(CXXFLAGS) -o $@ $^ $(LIBS)

clean:
	rm -f *.o *~ *.mod $(EXE) depend $(MEXA64Files) $(QMLibs) $(OBJS)

cleancuda:
	rm -rf $(CUDAObjs) $(CUDALinkObj)

depend :
	$(CXX) $(CXXFLAGS) -MM *.[cC] | perl dep.pl > $@
	bash fortran-dep.sh *.F >> $@

ifneq ($(MAKECMDGOALS), clean)
include depend
endif

