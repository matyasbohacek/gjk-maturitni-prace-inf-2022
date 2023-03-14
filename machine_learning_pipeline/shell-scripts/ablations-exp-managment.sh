
cd ..

# rotation-deg
python3 -m train --project-name "maturita--plant-identification--ablations" --learning-rate 0.01 --epochs 40 \
    --transforms-rotation --rotation-deg 10
python3 -m train --project-name "maturita--plant-identification--ablations" --learning-rate 0.01 --epochs 40 \
    --transforms-rotation --rotation-deg 15
python3 -m train --project-name "maturita--plant-identification--ablations" --learning-rate 0.01 --epochs 40 \
    --transforms-rotation --rotation-deg 20
python3 -m train --project-name "maturita--plant-identification--ablations" --learning-rate 0.01 --epochs 40 \
    --transforms-rotation --rotation-deg 25

# crop-min-pix
python3 -m train --project-name "maturita--plant-identification--ablations" --learning-rate 0.01 --epochs 40 \
    --transforms-random-crop --crop-min-pix 10
python3 -m train --project-name "maturita--plant-identification--ablations" --learning-rate 0.01 --epochs 40 \
    --transforms-random-crop --crop-min-pix 15
python3 -m train --project-name "maturita--plant-identification--ablations" --learning-rate 0.01 --epochs 40 \
    --transforms-random-crop --crop-min-pix 20
python3 -m train --project-name "maturita--plant-identification--ablations" --learning-rate 0.01 --epochs 40 \
    --transforms-random-crop --crop-min-pix 25

# brightness-range
python3 -m train --project-name "maturita--plant-identification--ablations" --learning-rate 0.01 --epochs 40 \
    --transforms-color-jitter --brightness-range 0.3 --saturation-range 0 --hue-range 0
python3 -m train --project-name "maturita--plant-identification--ablations" --learning-rate 0.01 --epochs 40 \
    --transforms-color-jitter --brightness-range 0.4 --saturation-range 0 --hue-range 0
python3 -m train --project-name "maturita--plant-identification--ablations" --learning-rate 0.01 --epochs 40 \
    --transforms-color-jitter --brightness-range 0.5 --saturation-range 0 --hue-range 0
python3 -m train --project-name "maturita--plant-identification--ablations" --learning-rate 0.01 --epochs 40 \
    --transforms-color-jitter --brightness-range 0.6 --saturation-range 0 --hue-range 0

# saturation-range
python3 -m train --project-name "maturita--plant-identification--ablations" --learning-rate 0.01 --epochs 40 \
    --transforms-color-jitter --brightness-range 0 --saturation-range 0.3 --hue-range 0
python3 -m train --project-name "maturita--plant-identification--ablations" --learning-rate 0.01 --epochs 40 \
    --transforms-color-jitter --brightness-range 0 --saturation-range 0.4 --hue-range 0
python3 -m train --project-name "maturita--plant-identification--ablations" --learning-rate 0.01 --epochs 40 \
    --transforms-color-jitter --brightness-range 0 --saturation-range 0.5 --hue-range 0
python3 -m train --project-name "maturita--plant-identification--ablations" --learning-rate 0.01 --epochs 40 \
    --transforms-color-jitter --brightness-range 0 --saturation-range 0.6 --hue-range 0

# hue-range
python3 -m train --project-name "maturita--plant-identification--ablations" --learning-rate 0.01 --epochs 40 \
    --transforms-color-jitter --brightness-range 0 --saturation-range 0 --hue-range 0.05
python3 -m train --project-name "maturita--plant-identification--ablations" --learning-rate 0.01 --epochs 40 \
    --transforms-color-jitter --brightness-range 0 --saturation-range 0 --hue-range 0.1
python3 -m train --project-name "maturita--plant-identification--ablations" --learning-rate 0.01 --epochs 40 \
    --transforms-color-jitter --brightness-range 0 --saturation-range 0 --hue-range 0.15
python3 -m train --project-name "maturita--plant-identification--ablations" --learning-rate 0.01 --epochs 40 \
    --transforms-color-jitter --brightness-range 0 --saturation-range 0 --hue-range 0.2
