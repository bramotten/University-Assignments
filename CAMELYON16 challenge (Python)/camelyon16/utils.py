from __future__ import print_function

TUMOR_WSI_PREP_START = 0
TUMOR_WSI_PREP_END = 2
NORMAL_WSI_PREP_START = 0
NORMAL_WSI_PREP_END = 2
TUMOR_ROI_START = TUMOR_WSI_PREP_START
TUMOR_ROI_END = TUMOR_WSI_PREP_END
NORMAL_ROI_START = NORMAL_WSI_PREP_START
NORMAL_ROI_END = NORMAL_WSI_PREP_END

BATCH_SIZE = 32
N_TRAIN_SAMPLES = 288000
N_VALIDATION_SAMPLES = 10000
N_SAMPLES_PER_TRAIN_SHARD = 1000
N_SAMPLES_PER_VALIDATION_SHARD = 250

N_TRAIN_SHARDS = N_TRAIN_SAMPLES / N_SAMPLES_PER_TRAIN_SHARD
N_VAL_SHARDS = N_VALIDATION_SAMPLES / N_SAMPLES_PER_VALIDATION_SHARD
N_NUM_THREADS = 4

NUM_NEGATIVE_PATCHES_FROM_EACH_BBOX = 100
NUM_POSITIVE_PATCHES_FROM_EACH_BBOX = 500
PATCH_INDEX_NEGATIVE = 500000  # was 70000
PATCH_INDEX_POSITIVE = 700000

TUMOR_PROB_THRESHOLD = 0.90
PIXEL_WHITE = 255
PIXEL_BLACK = 0

PATCH_SIZE = 512
PATCH_NORMAL_PREFIX = 'normal_'
PATCH_TUMOR_PREFIX = 'tumor_'
PATCH_AUG_NORMAL_PREFIX = 'aug_false_normal_'
PATCH_AUG_TUMOR_PREFIX = 'aug_false_tumor_'
PREFIX_SHARD_TRAIN = 'train'
PREFIX_SHARD_AUG_TRAIN = 'train-aug'
PREFIX_SHARD_VALIDATION = 'validation'
PREFIX_SHARD_AUG_VALIDATION = 'validation-aug'

PATCH_DIR = '/scratch/shared/camelyon16/bram/' # best use ..on16/512/ for reading TF records.
DATA_DIR = '/projects/2/managed_datasets/CAMELYON16/' # only non-777 folder.
OUTPUT_DIR = PATCH_DIR + 'Processed/patch-based-classification/tf-records/'

TUMOR_WSI_PATH = DATA_DIR + 'TrainingData/Train_Tumor'
NORMAL_WSI_PATH = DATA_DIR + 'TrainingData/Train_Normal'
TUMOR_MASK_PATH = DATA_DIR + 'TrainingData/Ground_Truth/Mask'
TEST_WSI_PATH = DATA_DIR + 'testset'

PATCHES_TRAIN_DIR = PATCH_DIR + 'Processed/patch-based-classification/raw-data/train/'
PATCHES_VALIDATION_DIR = PATCH_DIR + \
    'Processed/patch-based-classification/raw-data/validation/'
PATCHES_TRAIN_NEGATIVE_PATH = PATCHES_TRAIN_DIR + 'label-0/'
PATCHES_TRAIN_POSITIVE_PATH = PATCHES_TRAIN_DIR + 'label-1/'
PATCHES_VALIDATION_NEGATIVE_PATH = PATCHES_VALIDATION_DIR + 'label-0/'
PATCHES_VALIDATION_POSITIVE_PATH = PATCHES_VALIDATION_DIR + 'label-1/'

PATCHES_TRAIN_AUG_DIR = PATCH_DIR + \
    'Processed/patch-based-classification/raw-data-aug/train/'
PATCHES_VALIDATION_AUG_DIR = PATCH_DIR + \
    'Processed/patch-based-classification/raw-data-aug/validation/'
PATCHES_TRAIN_AUG_NEGATIVE_PATH = PATCHES_TRAIN_AUG_DIR + 'label-0/'
PATCHES_TRAIN_AUG_POSITIVE_PATH = PATCHES_TRAIN_AUG_DIR + 'label-1/'
PATCHES_TRAIN_AUG_EXCLUDE_MIRROR_WSI_NEGATIVE_PATH = PATCHES_TRAIN_AUG_DIR + \
    'exclude-mirror-label-0/'
PATCHES_TRAIN_AUG_EXCLUDE_MIRROR_WSI_POSITIVE_PATH = PATCHES_TRAIN_AUG_DIR + \
    'exclude-mirror-label-1/'
PATCHES_VALIDATION_AUG_NEGATIVE_PATH = PATCHES_VALIDATION_AUG_DIR + 'label-0/'
PATCHES_VALIDATION_AUG_POSITIVE_PATH = PATCHES_VALIDATION_AUG_DIR + 'label-1/'

TRAIN_TUMOR_WSI_PATH = DATA_DIR + 'TrainingData/Train_Tumor'
TRAIN_NORMAL_WSI_PATH = DATA_DIR + 'TrainingData/Train_Normal'
TRAIN_TUMOR_MASK_PATH = DATA_DIR + 'TrainingData/Ground_Truth/Mask'
PROCESSED_PATCHES_NORMAL_NEGATIVE_PATH = PATCH_DIR + \
    'Processed/patch-based-classification/normal-label-0/'
PROCESSED_PATCHES_TUMOR_NEGATIVE_PATH = PATCH_DIR + \
    'Processed/patch-based-classification/tumor-label-0/'
PROCESSED_PATCHES_POSITIVE_PATH = PATCH_DIR + \
    'Processed/patch-based-classification/label-1/'
PROCESSED_PATCHES_FROM_USE_MASK_POSITIVE_PATH = PATCH_DIR + \
    'Processed/patch-based-classification/use-mask-label-1/'
PATCH_NORMAL_PREFIX = 'normal_'
PATCH_TUMOR_PREFIX = 'tumor_'

TRAIN_TF_RECORDS_DIR = PATCH_DIR + \
    'Processed/patch-based-classification/tf-records/'
HEAT_MAP_RAW_PATCHES_DIR = PATCH_DIR + 'Processed/heat-map/patches/raw/'
HEAT_MAP_TF_RECORDS_DIR = PATCH_DIR + \
    'Processed/heat-map/patches/tf-records/'
HEAT_MAP_WSIs_PATH = PATCH_DIR + 'Processed/heat-map/WSIs/'
TRAIN_DIR = PATCH_DIR + 'training/all_models/model8/'
EVAL_DIR = PATCH_DIR + 'evaluation'

def get_filename_from_path(file_path):
    path_tokens = file_path.split('/')
    filename = path_tokens[path_tokens.__len__() - 1].split('.')[0]
    return filename
