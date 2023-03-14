
cd ..

python3 -m train --learning-rate 0.1 --epochs 60
python3 -m train --learning-rate 0.01 --epochs 60
python3 -m train --learning-rate 0.001 --epochs 60
python3 -m train --learning-rate 0.0001 --epochs 60

python3 -m train --learning-rate 0.01 --epochs 60 --transforms-color-jitter
python3 -m train --learning-rate 0.01 --epochs 60 --transforms-random-crop
python3 -m train --learning-rate 0.01 --epochs 60 --transforms-rotation
python3 -m train --learning-rate 0.01 --epochs 60 --transforms-color-jitter --transforms-random-crop
python3 -m train --learning-rate 0.01 --epochs 60 --transforms-random-crop --transforms-rotation
python3 -m train --learning-rate 0.01 --epochs 60 --transforms-rotation --transforms-color-jitter
python3 -m train --learning-rate 0.01 --epochs 60 --transforms-color-jitter --transforms-random-crop --transforms-rotation
