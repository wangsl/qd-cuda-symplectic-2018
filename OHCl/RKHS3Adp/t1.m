
close all
clear all
clc

format long

H2eV = 27.21138505;

addpath('/home/wang/matlab/qd-cuda-symplectic-2018/build/OHCl/RKHS3Adp')

rHCl = 2.41041209;
rOH = 100.0;
rOCl = rHCl + rOH;
v = OHClRKHSMex(rOH, rOCl, rHCl)

rHCl = 2.7107;
rOH = 2.3437;
theta = 135.95;
rOCl = sqrt(rHCl^2 + rOH^2 - 2*rHCl*rOH*cos(theta/180*pi));
v = OHClRKHSMex(rOH, rOCl, rHCl)
v*627.5095
v*H2eV

