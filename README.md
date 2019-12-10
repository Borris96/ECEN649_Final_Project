# ECEN - 649 Final Project
An implementation of viola-jones algorithm to detect faces
Ruijing Bao, UIN: 827005508
### Introduction

* This project is wirtten in Matlab.
* Preprocessing: Integral all images to order to get a faster training speed
* Training weak classifiers from Haar-like features
* Using Adaboost to obtain stronger classifiers
* Using a cascade method to detect real-life photos

### Instructions

There are two parts of the code.

`trainHaar` implements the alogorithm mentioned in the original paper. I trained classifiers using Haar-like features.

The main class is 'trainHaar.m'. You can just click 'run' button to get a trained model.

By adjusting iterations rounds, you can do adaboost different times.

There are some function files in the folder to support the training.

`detectFaces` uses the trained classifiers to detect real-life faces. I use my own photo as a test.

You can call detectFaces('') function to detect any real-life photos. By adjusting the iterations of running, or by adjusting the threshold of the cascade function, you can get desired results. 

For example, run `detectFaces('me.png')`.

### Bibliography
* Viola, Paul, and Michael Jones. "Rapid object detection using a boosted cascade of simple features." CVPR (1) 1.511-518 (2001): 3.
