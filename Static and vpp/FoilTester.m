%% foil tester
clc; clear; close all;

global vb thetaL;

vb_fps = 20.5;
vb = 6.120384;
thetaL = 0;
centerFoilTest = CenterFoil(thetaL, 0.785, 0.10);  %

centerFoilTest.DisplayGeometry();  %
centerFoilTest.DisplayForces();     % 
