#!/bin/bash
#it is necesary to change it by the dataset path

#------------------------------------
# Stereo-Inertial Examples
echo "Launching MH01 with Stereo-Inertial sensor"
./Examples/Stereo-Inertial/stereo_inertial_euroc ./Vocabulary/ORBvoc.txt ./Examples/Stereo-Inertial/EuRoC.yaml ~/Datasets/EuRoC/MH01 ./Examples/Stereo-Inertial/EuRoC_TimeStamps/MH01.txt dataset-MH01_stereoi


echo "Launching V102 with Stereo-Inertial sensor"
./Examples/Stereo-Inertial/stereo_inertial_euroc ./Vocabulary/ORBvoc.txt ./Examples/Stereo-Inertial/EuRoC.yaml ~/Datasets/EuRoC/V102 ./Examples/Stereo-Inertial/EuRoC_TimeStamps/V102.txt dataset-V102_stereoi
