The main function is "pipeline" which can be used to construct, train and test a specific model.

Example invocation of the function:
---------------------------------------------------
pipeLine(50, ‘train’, ‘opp’,’dense', 800)

Creates four classifiers with a codebook of 800 visual words, from intensity and opponent colorspace channels.

50 = amount of images per class to create the codebook/visual vocabulary .
‘train’ = mode, this could be train or test.
‘app’= color space model. When you use ‘’ by default grayscale images will be used.
‘dense’= sampling method. This could be dense or point sampling.

800 = vocabulary size.

In order to test the classifiers call the same function with:

pipeLine(50, ‘test’, ‘opp’,’dense', 800).

The only difference is the mode, this is test now instead of train.

The program will load all the models and files it created while training.

**************** compute_SIFT_desc.m ***********************
Computes shift descriptors for an image, this could be done by using dense or point sampling or both.

**************** convertColorspace.m ***********************
Coverts an image to opponent  or rgb colorspace.

**************** featureExtractionKmeans.m ***********************
Computes the visual vocabulary by means of k means clustering.

**************** featureExtractionv2.m ***********************
Extracts the SIFT feature descriptions of a specific image category.

**************** generate_html.m ***********************
Generates the result template.

**************** kMeansClustering.m ***********************
Wrapping function for VL Feat k means function.

**************** loadMatrixFromFile.m ***********************
Loads a stored matrix from file (can only contain one variable)

**************** processColorChannels.m ***********************
Extracts the SIFT features from the separate color channels of a specific colorspace.

**************** quantizeFeatures.m ***********************
Quantization of image features to visual words.
