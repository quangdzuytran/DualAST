#!/bin/bash
# source /opt/miniconda3/bin/activate
# conda activate dualast
for artist in 'claude-monet' 'paul-cezanne' 'vincent-van-gogh'
    do
        python main.py --model_name=$artist \
                --phase=inference \
                --image_size=1280 \
                --ii_dir=images/validation/ \
                --reference=images/reference/$artist/1.jpg \
                --save_dir=images/val_res/ \
                --ckpt_nmbr=300000
    done
