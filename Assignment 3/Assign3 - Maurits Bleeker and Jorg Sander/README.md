Computer Visions 1 - Lab assignment 3
=================================
Maurits Bleeker - 10694439
Jörg Sander - 10881530


For section 1:
=============================
HarrisCornerDetectorv2.m

A demo function that uses the Harris Corner Detector Algorithm to find corners in images.
It returns the H matrix, the rows of the detected corner points r, and the columns of those points c.
For visualization, use plot_yn = true as input parameter, then the results will be plotted.

For section 3:
=============================
LucasKanadeAlgorithm.m

A demo function which returns [X , Y, u,v]. X and Y are the coordinates in the input images of the velocity vectors. u and v
are the velocity vectors for the pixels in a window. Use plot_results = true for visualisation of the optical flow for the input images

For section 4:
============================
createOpticalFlow.m

Demo functions which run the trackers for a sample of a image sequences.

LucasKanadeTrackingPoints.m

A helper function for tracking the corner point in a sample of a image sequences, slightly different then LucasKanadeAlgorithm.m
because the latter uses dense sampling.
