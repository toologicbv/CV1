To run the whole for example pipeline. 

pipeLine(50, ‘train’, ‘opp’,’dense', 800)

This will run train all the models you need.

50 = amount of images per class to create the codebook/visual vocabulary .
‘train’ = mode, this could be train or test.
‘app’= color space model. When you use ‘’ by default grayscale images will be used.
‘dense’= sailing method. This could be dense or point sampling.

800 = vocabulary size.

When all the models are trained call the same function again like this.

pipeLine(50, ‘test’, ‘opp’,’dense', 800).

The only difference is the mode, this is test now instead of train. 

The program will load all the models and files it created while training default. 

**************** compute_SIFT_desc.m ***********************
Compute shift descriptors for a image, this could be done by using dense or point sampling or both.
**************** convertColorspace.m ***********************
Covert a images to pop of or rgb values.

**************** featureExtractionKmeans.m ***********************

**************** featureExtractionv2.m ***********************

**************** generate_htmlc.m ***********************

**************** kMeansClustering.m ***********************

**************** loadMatrixFromFile.m ***********************

**************** pipeLine.m ***********************

**************** processColorChannels.m ***********************

**************** quantizeFeatures.m ***********************