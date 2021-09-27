Stuff I've changed but am not sure about:

- The high=...-1 in wsi_ops lines like X = np.random.random_integers(b_x_start, high=b_x_end - 1, size=NUM_NEGATIVE_PATCHES_FROM_EACH_BBOX).
- Have never run stain_normalization. Arjun does it on data we don't have and I haven't looked for.

Stuff I'm just not sure about:

- Order matters in some places. That makes threading impossible without a lot of rewriting. But indices reset too on other places, e.g. every run of patch extraction starts at 700000 (that PATCH_NEGATIVE thing). So do we need to do one run though all WSI's? Takes at least a few hours or some rewriting to make threading possible.
- The np.random.random_integer thing for the bounding boxes.
- The fugly and inconsistent/-complete directory names. Therefore also not sure if everything's there. (Validation label-1 could remain empty for instance.)
- Not doing augmented patch extraction now.

Stuff to do:

- Cleaner (more minimal and less 'repeating') utils.py
- Nicer in-/output folder structure.
- Try fixing stupid stuff in ROI and patch extraction. Wrap (most) writes in an if os.path.exists() and other stuff like that too.
- Fix TF record writing. Could also be the png's are the problem.
- Check Chexnet. Now fails because of the corrupt TF records.
