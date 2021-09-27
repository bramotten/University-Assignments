Using the `*chex*` versions, and (depending on patch size in preprocessing) the 512 model.

Haven't hard-coded folders in `resnet_main_chex.py`, the file to be run (typically). The arguments specifying the folders to use should be something (or exactly) like:

- `--data_dir=/scratch/shared/camelyon16/512/Processed/patch-based-classification/tf-records`
- `--model_dir=/scratch/shared/camelyon16/bram/resnet2`
- `--checkpoint_path=/scratch-shared/camelyon16-pretrain/model_512.ckpt-13583`