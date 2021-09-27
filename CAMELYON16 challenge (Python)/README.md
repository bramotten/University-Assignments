Based on <https://github.com/arjunvekariyagithub/camelyon16-grand-challenge>

A whole slide image has a size matching about 200000 x 100000
if we would deal with all regions we would need enormous amounts
of computational power. Thus, we pre-process these slides to more be
more of use to us.

Check (and modify) `./utils.py` for folder structure. It's not pretty.

## preprocess/extract_ROIs.py

We start with searching so called regions of interest. Not all parts
of the WSI are actual useful so to reduce the needed computational power
we only extract patches from regions that contain cells.

## preprocess/extract_patches.py

from the ROI's obtained in the previous operation we now continue to
extract the actual patches we will be using to train our residual network.
These patches will either be extracted from normal and tumour areas. Which are
then saved in folders labelled respectively.

## preprocess/create_tfrecords.py

Converts the eventual extracted patches to the TFRecords file format
to be able to use the images with TensorFlow.
The image data set is expected to reside in JPEG files created above.

## preprocess/verify_tfrecords.py

Checks if a set of TFRecords appear to be valid.

Specifically, this checks whether the provided record sizes are consistent and
that the file does not end in the middle of a record. It does not verify the
CRCs.

## ops/wsi_ops.py

Supports preprocessing

## chexnet_pretrain

Network part of implementation. Contains an own readme, is incomplete due
to failures in preprocessing.