
# $Id$

.DEFAULT: .F .F90 .c .C
.SUFFIXES: .F .F90 .c .C

SRC = $(PWD)
O = $(SRC)/../../build/common-hip

F77 = gfortran
F90 = gfortran
CC = gcc
CXX = g++
NVCC = hipcc

CFLAGS = -O3 -fPIC -fopenmp -D__HIP_PLATFORM_AMD__

FFLAGS = -O3 -fPIC -fopenmp -ffixed-line-length-132

NVCCINCLUDE = -I/opt/rocm/hipfft/include  -I/opt/rocm/hipblas/include -I/opt/rocm/hip/include \
	-I$(MATLAB_ROOT)/extern/include

NVCCFLAGS = $(NVCCINCLUDE) -O3 -fPIC --amdgpu-target=gfx906 

CXXFLAGS = -std=c++11 -O3 -fPIC -fopenmp  -D__HIP_PLATFORM_AMD__ $(NVCCINCLUDE)

Link = $(NVCC)

#LIBS =  -L/usr/local/cuda/lib64 -lcufft -lcublas -lcudart #-lmkl_rt
LIBS = -L/opt/rocm/lib -lrocfft -lrocblas -lhipblas -lgomp -llapack 

MEXA64Files = $(O)/cudaSymplectic.mexa64 #$(O)/DMBEIVMex.mexa64

CUDAObjs = $(O)/cudaOpenmpMD.o $(O)/cudaUtils.o $(O)/wavepacketson1device.o \
	$(O)/omegawavepacket.o $(O)/numGradient.o  $(O)/reactProb.o
 
CUDALinkObj = $(O)/cudalink.o

OBJS = $(O)/cudaSymplectic.o  $(O)/matlabUtils.o \
	$(O)/matlabStructures.o  $(O)/matlabStructuresio.o \
	$(O)/matlabData.o \
	$(O)/die.o  $(O)/indent.o  $(O)/out.o \
	$(O)/rmatalgo.o  $(O)/rmat.o  $(O)/rmato.o \
	$(O)/mex2matlab.o \
	$(CUDAObjs) #$(CUDALinkObj)

QMLibs = $(O)/libqmdyn.a

.DEFAULT_GOAL := $(O)/cudaSymplectic.mexa64

all: $(MEXA64Files)

#$(EXE) : $(OBJS)
#	$(Link) $(CXXFLAGS) -o $(EXE) $(OBJS) $(LIBS)

$(O)/%.o: %.c
	cd $(O) ; $(CC)  $(cFLAGS) -c $(SRC)/$<
$(O)/%.o: %.C
	cd $(O) ; $(CXX) $(CXXFLAGS) -c $(SRC)/$<
$(O)/%.o: %.F
	cd $(O) ; $(F77) $(FFLAGS) -c $(SRC)/$<
$(O)/%.o: %.F90
	cd $(O) ; $(F90) $(FFLAGS) -c $(SRC)/$<
$(O)/%.o: %.cu
	cd $(O) ; $(NVCC) $(NVCCFLAGS) -fgpu-rdc -c $(SRC)/$<

$(CUDALinkObj): $(CUDAObjs)
	cd $(O); $(NVCC) -fgpu-rdc --hip-link $(CUDAObjs) -o $(CUDALinkObj)

%io.C: %.h
	perl io.pl $<

$(QMLibs): $(OBJS)
	cd $(O); ar -crusv $(QMLibs) $(OBJS)

$(O)/%.mexa64: $(O)/%.o $(OBJS) #$(QMLibs)
	cd $(O); $(Link) -shared -fgpu-rdc --hip-link -o $@ $^ $(LIBS)

clean:
	rm -f *.o *~ *.mod $(EXE) depend $(MEXA64Files) $(QMLibs) $(OBJS) $(O)/*.optrpt

cleancuda:
	rm -rf $(CUDAObjs) $(CUDALinkObj)

depend :
	$(CXX) $(CXXFLAGS) -D__HIP_PLATFORM_AMD__ -MM *.[cC] | perl dep.pl > $@
	$(NVCC) $(NVCCINCLUDE) -M *.cu | perl dep.pl >> $@
	bash dep.sh *.F >> $@

ifneq ($(MAKECMDGOALS), clean)
include depend
endif

