Computer Visions 1 - Lab assignment 4
=================================
Maurits Bleeker - 10694439
Jörg Sander - 10881530


For section 1:
=============================
(1) keypointMatches.m

A demo functions that finds keypoint matchings between two input images based on Loewe SIFT
implementation of Andrea Vidaldi

(2) plotMatchingPoints.m

Plots a random subset of the matching points between image 1 and 2 on the concatenated image and connects
them with lines

(3) RANSACv3.m

A demo function that uses RANSAC algorithm to find best transformation parameters. Also returns the best set
of matching points belonging to the t-parameters.

Helper functions:
-------------------------
affine_trans.m
nearestNeighbor.m
detMaxImageSize.m

For section 2:
=============================


(1) image_stitching.m

A demo functions that stitches two input images togehter and create a produce a segmented images from the two input images. 


(2) RANSACv1.m

Original RANSAC we developed, slightly different function then v3 but easier to use for images stitiching. 
