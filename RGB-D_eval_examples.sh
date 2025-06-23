#!/bin/bash
# Change this to your actual dataset path

# ------------------------------------
# Sequence: fr3_office
echo "Launching fr3_office with RGB-D sensor"
./Examples/RGB-D/rgbd_tum ./Vocabulary/ORBvoc.txt ./Examples/RGB-D/TUM3.yaml \
    ~/Datasets/TUM_RGB-D/fr3-o-s ./Examples/RGB-D/associations/fr3_office_val.txt \
    KeyFrameTrajectory_fr3_office.txt
echo "------------------------------------"
echo "Evaluation of fr3_office trajectory"
python3 evaluation/evaluate_ate_scale.py ~/Datasets/TUM_RGB-D/fr3-o-s/groundtruth.txt \
    KeyFrameTrajectory_fr3_office.txt --plot fr3_office_ate.pdf

# ------------------------------------
# Sequence: fr3_structure_texture
echo "Launching fr3_structure_texture with RGB-D sensor"
./Examples/RGB-D/rgbd_tum ./Vocabulary/ORBvoc.txt ./Examples/RGB-D/TUM3.yaml \
    ~/Datasets/TUM_RGB-D/fr3-s-t ./Examples/RGB-D/associations/fr3_str_tex_far.txt \
    KeyFrameTrajectory_fr3_strtex.txt
echo "------------------------------------"
echo "Evaluation of fr3_structure_texture trajectory"
python3 evaluation/evaluate_ate_scale.py ~/Datasets/TUM_RGB-D/fr3-s-t/groundtruth.txt \
    KeyFrameTrajectory_fr3_strtex.txt --plot fr3_strtex_ate.pdf
