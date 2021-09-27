from __future__ import print_function
import os
import sys
import glob
import os
import cv2
import time
import multiprocessing
import numpy as np
from PIL import Image
from openslide import OpenSlide, OpenSlideUnsupportedFormatErro

# Make it possible to import from higher directory by adding parent directory
# to path. This should work on Python 2 and 3, and for Windows and Unix-based.
cur_folder = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
sep = '/'  # \\ on Windows
parent_folder = cur_folder[:cur_folder.rfind(sep)]
sys.path.append(parent_folder)
from camelyon16.utils import *

class WSI(object):
    """
    # ================================
    # Class to annotate WSIs with ROIs
    # ================================
    """
    index = 0
    negative_patch_index = 118456  # TODO: store in py, whatever it is.
    positive_patch_index = 2230
    wsi_paths = []
    mask_paths = []
    def_level = 7
    key = 0

    def extract_patches_mask(self, bounding_boxes):
        """
        Extract positive patches targeting annotated tumor region

        Save extracted patches to desk as .png image files

        :param bounding_boxes: list of bounding boxes corresponds to tumor regions
        :return:

        """
        mag_factor = pow(2, self.level_used)

        for i, bounding_box in enumerate(bounding_boxes):
            b_x_start = int(bounding_box[0]) * mag_factor
            b_y_start = int(bounding_box[1]) * mag_factor
            b_x_end = (int(bounding_box[0]) +
                       int(bounding_box[2])) * mag_factor
            b_y_end = (int(bounding_box[1]) +
                       int(bounding_box[3])) * mag_factor
            X = np.random.random_integers(b_x_start, high=b_x_end, size=500)
            Y = np.random.random_integers(b_y_start, high=b_y_end, size=500)

            for x, y in zip(X, Y):
                mask = self.mask_image.read_region(
                    (x, y), 0, (PATCH_SIZE, PATCH_SIZE))
                mask_gt = np.array(mask)
                mask_gt = cv2.cvtColor(mask_gt, cv2.COLOR_BGR2GRAY)

                white_pixel_cnt_gt = cv2.countNonZero(mask_gt)

                if white_pixel_cnt_gt > ((PATCH_SIZE * PATCH_SIZE) * TUMOR_PROB_THRESHOLD):
                    patch = self.wsi_image.read_region(
                        (x, y), 0, (PATCH_SIZE, PATCH_SIZE))
                    patch.save(PROCESSED_PATCHES_FROM_USE_MASK_POSITIVE_PATH + PATCH_TUMOR_PREFIX +
                               str(self.positive_patch_index) + '.png', 'PNG')
                    self.positive_patch_index += 1
                    patch.close()

                mask.close()

    def extract_patches_normal(self, bounding_boxes):
        """
        Extract negative patches from Normal WSIs

        Save extracted patches to desk as .png image files

        :param bounding_boxes: list of bounding boxes corresponds to detected ROIs
        :return:

        """
        mag_factor = pow(2, self.level_used)

        for i, bounding_box in enumerate(bounding_boxes):
            b_x_start = int(bounding_box[0]) * mag_factor
            b_y_start = int(bounding_box[1]) * mag_factor
            b_x_end = (int(bounding_box[0]) +
                       int(bounding_box[2])) * mag_factor
            b_y_end = (int(bounding_box[1]) +
                       int(bounding_box[3])) * mag_factor
            X = np.random.random_integers(b_x_start, high=b_x_end, size=500)
            Y = np.random.random_integers(b_y_start, high=b_y_end, size=500)

            for x, y in zip(X, Y):
                patch = self.wsi_image.read_region(
                    (x, y), 0, (PATCH_SIZE, PATCH_SIZE))
                patch_array = np.array(patch)

                patch_hsv = cv2.cvtColor(patch_array, cv2.COLOR_BGR2HSV)
                lower_red = np.array([20, 20, 20])
                upper_red = np.array([200, 200, 200])
                mask = cv2.inRange(patch_hsv, lower_red, upper_red)
                white_pixel_cnt = cv2.countNonZero(mask)

                if white_pixel_cnt > ((PATCH_SIZE * PATCH_SIZE) * 0.50):
                    patch.save(PROCESSED_PATCHES_NORMAL_NEGATIVE_PATH + PATCH_NORMAL_PREFIX +
                               str(self.negative_patch_index) + '.png', 'PNG')
                    self.negative_patch_index += 1

                patch.close()

    def extract_patches_tumor(self, bounding_boxes):
        """
        Extract both, negative patches from Normal area and positive patches from Tumor area

        Save extracted patches to desk as .png image files

        :param bounding_boxes: list of bounding boxes corresponds to detected ROIs
        :return:

        """
        mag_factor = pow(2, self.level_used)

        for i, bounding_box in enumerate(bounding_boxes):
            b_x_start = int(bounding_box[0]) * mag_factor
            b_y_start = int(bounding_box[1]) * mag_factor
            b_x_end = (int(bounding_box[0]) +
                       int(bounding_box[2])) * mag_factor
            b_y_end = (int(bounding_box[1]) +
                       int(bounding_box[3])) * mag_factor
            X = np.random.random_integers(b_x_start, high=b_x_end, size=500)
            Y = np.random.random_integers(b_y_start, high=b_y_end, size=500)

            for x, y in zip(X, Y):
                patch = self.wsi_image.read_region(
                    (x, y), 0, (PATCH_SIZE, PATCH_SIZE))
                mask = self.mask_image.read_region(
                    (x, y), 0, (PATCH_SIZE, PATCH_SIZE))
                mask_gt = np.array(mask)
                mask_gt = cv2.cvtColor(mask_gt, cv2.COLOR_BGR2GRAY)
                patch_array = np.array(patch)

                white_pixel_cnt_gt = cv2.countNonZero(mask_gt)

                if white_pixel_cnt_gt == 0:  # mask_gt does not contain tumor area
                    patch_hsv = cv2.cvtColor(patch_array, cv2.COLOR_BGR2HSV)
                    lower_red = np.array([20, 20, 20])
                    upper_red = np.array([200, 200, 200])
                    mask_patch = cv2.inRange(patch_hsv, lower_red, upper_red)
                    white_pixel_cnt = cv2.countNonZero(mask_patch)

                    if white_pixel_cnt > ((PATCH_SIZE * PATCH_SIZE) * 0.50):
                        file_name = PROCESSED_PATCHES_TUMOR_NEGATIVE_PATH + \
                            PATCH_NORMAL_PREFIX + \
                            str(self.negative_patch_index) + '.png'
                        patch.save(file_name, 'PNG')
                        self.negative_patch_index += 1
                else:  # mask_gt contains tumor area
                    if white_pixel_cnt_gt >= ((PATCH_SIZE * PATCH_SIZE) * TUMOR_PROB_THRESHOLD):
                        file_name = PROCESSED_PATCHES_POSITIVE_PATH + \
                            PATCH_TUMOR_PREFIX + \
                            str(self.positive_patch_index) + '.png'
                        patch.save(file_name, 'PNG')
                        self.positive_patch_index += 1

                patch.close()
                mask.close()

    def read_wsi_mask(self, wsi_path, mask_path):
        try:
            self.cur_wsi_path = wsi_path
            self.wsi_image = OpenSlide(wsi_path)
            self.mask_image = OpenSlide(mask_path)

            self.level_used = min(self.def_level,
                                  self.wsi_image.level_count - 1,
                                  self.mask_image.level_count - 1)

            self.mask_pil = self.mask_image.read_region((0, 0), self.level_used,
                              self.mask_image.level_dimensions[self.level_used])

            self.mask = np.array(self.mask_pil)

        except OpenSlideUnsupportedFormatError:
            print('Exception: OpenSlideUnsupportedFormatError')
            return False

        return True

    def read_wsi_normal(self, wsi_path):
        """
        # =====================================================================================
        # read WSI image and resize
        # Due to memory constraint, we use down sampled (4th level, 1/32 resolution) image
        # ======================================================================================
        """
        try:
            self.cur_wsi_path = wsi_path
            self.wsi_image = OpenSlide(wsi_path)
            self.level_used = min(
                self.def_level, self.wsi_image.level_count - 1)

            self.rgb_image_pil = self.wsi_image.read_region((0, 0), self.level_used,
                                                            self.wsi_image.level_dimensions[self.level_used])
            self.rgb_image = np.array(self.rgb_image_pil)

        except OpenSlideUnsupportedFormatError:
            print('Exception: OpenSlideUnsupportedFormatError')
            return False

        return True

    def read_wsi_tumor(self, wsi_path, mask_path):
        """
            # =====================================================================================
            # read WSI image and resize
            # Due to memory constraint, we use down sampled (4th level, 1/32 resolution) image
            # ======================================================================================
        """
        try:
            self.cur_wsi_path = wsi_path
            self.wsi_image = OpenSlide(wsi_path)
            self.mask_image = OpenSlide(mask_path)

            self.level_used = min(
                self.def_level, self.wsi_image.level_count - 1, self.mask_image.level_count - 1)

            self.rgb_image_pil = self.wsi_image.read_region((0, 0), self.level_used,
                                                            self.wsi_image.level_dimensions[self.level_used])
            self.rgb_image = np.array(self.rgb_image_pil)

        except OpenSlideUnsupportedFormatError:
            print('Exception: OpenSlideUnsupportedFormatError')
            return False

        return True

    def find_roi_n_extract_patches_mask(self):
        mask = cv2.cvtColor(self.mask, cv2.COLOR_BGR2GRAY)
        contour_mask, bounding_boxes = self.get_image_contours_mask(
            np.array(mask), np.array(self.mask))

        self.mask_pil.close()
        self.extract_patches_mask(bounding_boxes)
        self.wsi_image.close()
        self.mask_image.close()

    def find_roi_n_extract_patches_normal(self):
        # So there needs to be a self.rgb_image here.
        hsv = cv2.cvtColor(self.rgb_image, cv2.COLOR_BGR2HSV)
        lower_red = np.array([20, 50, 20])
        upper_red = np.array([200, 150, 200])
        mask = cv2.inRange(hsv, lower_red, upper_red)

        close_kernel = np.ones((25, 25), dtype=np.uint8)
        image_close = Image.fromarray(cv2.morphologyEx(
            np.array(mask), cv2.MORPH_CLOSE, close_kernel))
        open_kernel = np.ones((30, 30), dtype=np.uint8)
        image_open = Image.fromarray(cv2.morphologyEx(
            np.array(image_close), cv2.MORPH_OPEN, open_kernel))
        contour_rgb, bounding_boxes = self.get_image_contours_normal(
            np.array(image_open), self.rgb_image)

        self.rgb_image_pil.close()
        self.extract_patches_normal(bounding_boxes)
        self.wsi_image.close()

    def find_roi_n_extract_patches_tumor(self):
        hsv = cv2.cvtColor(self.rgb_image, cv2.COLOR_BGR2HSV)
        lower_red = np.array([20, 20, 20])
        upper_red = np.array([255, 255, 255])
        mask = cv2.inRange(hsv, lower_red, upper_red)

        close_kernel = np.ones((50, 50), dtype=np.uint8)
        image_close = Image.fromarray(cv2.morphologyEx(
            np.array(mask), cv2.MORPH_CLOSE, close_kernel))

        open_kernel = np.ones((30, 30), dtype=np.uint8)
        image_open = Image.fromarray(cv2.morphologyEx(
            np.array(image_close), cv2.MORPH_OPEN, open_kernel))
        contour_rgb, bounding_boxes = self.get_image_contours_tumor(
            np.array(image_open), self.rgb_image)

        self.rgb_image_pil.close()
        self.extract_patches_tumor(bounding_boxes)
        self.wsi_image.close()
        self.mask_image.close()

    @staticmethod
    def get_image_contours_mask(cont_img, mask_img):
        _, contours, _ = cv2.findContours(
            cont_img, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        bounding_boxes = [cv2.boundingRect(c) for c in contours]
        contours_mask_image_array = np.array(mask_img)
        line_color = (255, 0, 0)  # blue color code
        cv2.drawContours(contours_mask_image_array,
                         contours, -1, line_color, 1)
        return contours_mask_image_array, bounding_boxes

    @staticmethod
    def get_image_contours_normal(cont_img, rgb_image):
        _, contours, _ = cv2.findContours(
            cont_img, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        bounding_boxes = [cv2.boundingRect(c) for c in contours]
        contours_rgb_image_array = np.array(rgb_image)
        line_color = (255, 0, 0)  # blue color code
        cv2.drawContours(contours_rgb_image_array, contours, -1, line_color, 3)
        return contours_rgb_image_array, bounding_boxes

    @staticmethod
    def get_image_contours_tumor(cont_img, rgb_image):
        _, contours, _ = cv2.findContours(
            cont_img, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        bounding_boxes = [cv2.boundingRect(c) for c in contours]
        contours_rgb_image_array = np.array(rgb_image)

        line_color = (255, 0, 0)  # blue color code
        cv2.drawContours(contours_rgb_image_array, contours, -1, line_color, 3)
        return contours_rgb_image_array, bounding_boxes

    def wait(self):
        self.key = cv2.waitKey(0) & 0xFF
        print('key: %d' % self.key)

        if self.key == 27:  # escape
            return False
        elif self.key == 81:  # <- (prev)
            self.index -= 1
            if self.index < 0:
                self.index = len(self.wsi_paths) - 1
        elif self.key == 83:  # -> (next)
            self.index += 1
            if self.index >= len(self.wsi_paths):
                self.index = 0

        return True


def run_on_tumor_data_and_mask(local_wsi, start, finish):
    local_wsi.wsi_paths = glob.glob(
        os.path.join(TRAIN_TUMOR_WSI_PATH, '*.tif'))
    local_wsi.wsi_paths.sort()
    local_wsi.wsi_paths = local_wsi.wsi_paths[start:finish]
    local_wsi.mask_paths = glob.glob(
        os.path.join(TRAIN_TUMOR_MASK_PATH, '*.tif'))
    local_wsi.mask_paths.sort()
    local_wsi.mask_paths = local_wsi.mask_paths[start:finish]

    count = start
    for wsi_path, mask_path in zip(local_wsi.wsi_paths, local_wsi.mask_paths):
        print("Tumor WSI numero", count)
        if local_wsi.read_wsi_tumor(wsi_path, mask_path):  # sets some wsi.variables
            local_wsi.find_roi_n_extract_patches_tumor()  # 'n' = 'and' in Arjun
        # TODO: check if can be removed.
        print("Tumor mask WSI numero", count)
        if local_wsi.read_wsi_mask(wsi_path, mask_path):
            local_wsi.find_roi_n_extract_patches_mask()
        count += 1


def run_on_normal_data(local_wsi, start, finish):
    local_wsi.wsi_paths = glob.glob(
        os.path.join(TRAIN_NORMAL_WSI_PATH, '*.tif'))
    local_wsi.wsi_paths.sort()
    local_wsi.wsi_paths = local_wsi.wsi_paths[start:finish]

    count = start
    for wsi_path in local_wsi.wsi_paths:
        print("Normal WSI numero", count)
        if local_wsi.read_wsi_normal(wsi_path):
            local_wsi.find_roi_n_extract_patches_normal()
        count += 1

if __name__ == '__main__':
    print("* Writing ROI's to folders like:")
    print("*", PROCESSED_PATCHES_TUMOR_NEGATIVE_PATH)
    print("* ------------------------------")
    start_time = time.time()
    run_on_tumor_data_and_mask(WSI(), TUMOR_WSI_PREP_START, TUMOR_WSI_PREP_END)
    run_on_normal_data(WSI(), NORMAL_WSI_PREP_START, NORMAL_WSI_PREP_END)
    print("* ------------------------------")
    print("Seconds elapsed:", time.time() - start_time)
