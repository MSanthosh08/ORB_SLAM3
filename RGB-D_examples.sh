#!/bin/bash
# it is necesary to change it by the dataset path

#------------------------------------
#for office sequenece
./Examples/RGB-D/rgbd_tum ./Vocabulary/ORBvoc.txt ./Examples/RGB-D/TUM3.yaml ~/Datasets/TUM_RGB-D/fr3-o-s ./Examples/RGB-D/associations/fr3_office_val.txt

#for structure texture
./Examples/RGB-D/rgbd_tum ./Vocabulary/ORBvoc.txt ./Examples/RGB-D/TUM3.yaml ~/Datasets/TUM_RGB-D/fr3-s-t ./Examples/RGB-D/associations/fr3_str_tex_far.txt

