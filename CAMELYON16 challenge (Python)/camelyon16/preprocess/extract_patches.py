from __future__ import print_function
import glob
import os
import cv2
import numpy as np
import os
import sys
# Make it possible to import from higher directory by adding parent directory
# to path. This should work on Python 2 and 3, and for Windows and Unix-based.
cur_folder = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
sep = '/'  # \\ on Windows
parent_folder = cur_folder[:cur_folder.rfind(sep)]
sys.path.append(parent_folder)
from camelyon16.utils import *
from camelyon16.ops.wsi_ops import PatchExtractor, WSIOps

"""
Extract positive patches from tumor area.
Save extracted patches to desk as .png image files.
"""
def extract_positive_patches_from_tumor_wsi(wsi_ops, patch_extractor,
                                            patch_index, augmentation=False):
    wsi_paths = glob.glob(os.path.join(TUMOR_WSI_PATH, '*.tif'))
    wsi_paths.sort()
    mask_paths = glob.glob(os.path.join(TUMOR_MASK_PATH, '*.tif'))
    mask_paths.sort()

    image_mask_pair = zip(wsi_paths, mask_paths)
    image_mask_pair = list(image_mask_pair)
    image_mask_pair = image_mask_pair[TUMOR_ROI_START:TUMOR_ROI_END]

    patch_save_dir = PATCHES_TRAIN_AUG_POSITIVE_PATH \
                        if augmentation \
                        else PATCHES_TRAIN_POSITIVE_PATH
    patch_prefix = PATCH_AUG_TUMOR_PREFIX \
                        if augmentation \
                        else PATCH_TUMOR_PREFIX

    for image_path, mask_path in image_mask_pair:
        print('extract_positive_patches_from_tumor_wsi(): %s' %
              get_filename_from_path(image_path))
        wsi_image, rgb_image, _, tumor_gt_mask, level_used = wsi_ops.read_wsi_tumor(
                                                image_path, mask_path)

        assert wsi_image is not None, 'Failed to read Whole Slide Image %s.' % image_path

        bounding_boxes = wsi_ops.find_roi_bbox_tumor_gt_mask(np.array(tumor_gt_mask))

        patch_index = patch_extractor.extract_positive_patches_from_tumor_region(
                                                wsi_image, np.array(tumor_gt_mask),
                                                level_used, bounding_boxes,
                                                patch_save_dir, patch_prefix,
                                                patch_index)
        print('Positive patch count: %d' % (patch_index - PATCH_INDEX_POSITIVE))
        wsi_image.close()

    return patch_index

"""
Extract negative patches from tumor area.
Save extracted patches to desk as .png image files.
"""
def extract_negative_patches_from_tumor_wsi(wsi_ops, patch_extractor,
                                            patch_index, augmentation=False):

    wsi_paths = glob.glob(os.path.join(TUMOR_WSI_PATH, '*.tif'))
    wsi_paths.sort()
    mask_paths = glob.glob(os.path.join(TUMOR_MASK_PATH, '*.tif'))
    mask_paths.sort()

    image_mask_pair = zip(wsi_paths, mask_paths)
    image_mask_pair = list(image_mask_pair)
    image_mask_pair = image_mask_pair[TUMOR_ROI_START:TUMOR_ROI_END]

    patch_save_dir = PATCHES_TRAIN_AUG_NEGATIVE_PATH \
                                            if augmentation \
                                            else PATCHES_TRAIN_NEGATIVE_PATH
    patch_prefix = PATCH_AUG_NORMAL_PREFIX  if augmentation \
                                            else PATCH_NORMAL_PREFIX

    for image_path, mask_path in image_mask_pair:
        print('extract_negative_patches_from_tumor_wsi(): %s' %
              get_filename_from_path(image_path))
        wsi_image, rgb_image, _, tumor_gt_mask, level_used = wsi_ops.read_wsi_tumor(
                                            image_path, mask_path)
        assert wsi_image is not None, 'Failed to read Whole Slide Image %s.' % image_path

        bounding_boxes, _, image_open = wsi_ops.find_roi_bbox(np.array(rgb_image))

        patch_index = patch_extractor.extract_negative_patches_from_tumor_wsi(https://docs.google.com/document/u/0/
                                            wsi_image, np.array(tumor_gt_mask),
                                            image_open, level_used,
                                            bounding_boxes, patch_save_dir,
                                            patch_prefix,
                                            patch_index)

        print('Negative patches count: %d' %
              (patch_index - PATCH_INDEX_NEGATIVE))

        wsi_image.close()

    return patch_index

"""
Extract negative patches from normal area.
Save extracted patches to desk as .png image files.
"""
def extract_negative_patches_from_normal_wsi(wsi_ops, patch_extractor,
                                             patch_index, augmentation=False):
    """
    Extracted up to Normal_060.

    :param wsi_ops:
    :param patch_extractor:
    :param patch_index:
    :param augmentation:
    :return:
    """
    wsi_paths = glob.glob(os.path.join(NORMAL_WSI_PATH, '*.tif'))
    wsi_paths.sort()

    wsi_paths = wsi_paths[NORMAL_ROI_START:NORMAL_ROI_END]

    patch_save_dir = PATCHES_VALIDATION_AUG_NEGATIVE_PATH \
            `                           if augmentation \
                                        else PATCHES_VALIDATION_NEGATIVE_PATH
    patch_prefix = PATCH_AUG_NORMAL_PREFIX \
                                        if augmentation \
                                        else PATCH_NORMAL_PREFIX

    for image_path in wsi_paths:
        print('extract_negative_patches_from_normal_wsi(): %s' %
              get_filename_from_path(image_path))
        wsi_image, rgb_image, level_used = wsi_ops.read_wsi_normal(image_path)
        assert wsi_image is not None, 'Failed to read Whole Slide Image %s.' % image_path

        bounding_boxes, _, image_open = wsi_ops.find_roi_bbox(np.array(rgb_image))

        patch_index = patch_extractor.extract_negative_patches_from_normal_wsi(
                                                                    wsi_image,
                                                                    image_open,
                                                                    level_used,
                                                                    bounding_boxes,
                                                                    patch_save_dir,
                                                                    patch_prefix,
                                                                    patch_index)
        print('Negative patches count: %d' %
              (patch_index - PATCH_INDEX_NEGATIVE))

        wsi_image.close()

    return patch_index

"""
State the starting indexes for the patches and
initiate the patch extraction.
"""
def extract_patches(ops, pe):
    patch_index_positive = PATCH_INDEX_POSITIVE
    patch_index_negative = PATCH_INDEX_NEGATIVE
    patch_index_negative = extract_negative_patches_from_tumor_wsi(
        ops, pe, patch_index_negative)
    extract_negative_patches_from_normal_wsi(ops, pe, patch_index_negative)
    extract_positive_patches_from_tumor_wsi(ops, pe, patch_index_positive)


if __name__ == '__main__':
    print("* Writing to dirs like:")
    print("*", PATCHES_TRAIN_NEGATIVE_PATH)
    print(" (Indices may be off by one.)")
    print("* ------------------------------")
    extract_patches(WSIOps(), PatchExtractor())
    print("* ------------------------------")
