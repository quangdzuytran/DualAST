# DualAST: Dual Style-Learning Networks for Artistic Style Transfer
Ứng dụng TTNT trong làm giàu dữ liệu ảnh-video.

Nhóm DKV:
- Trần Quang Duy - 18120022
- Dương Anh Kiệt - 18120046
- Nguyễn Duy Vũ - 18120264

![image](https://github.com/HalbertCH/DualAST/blob/main/results/1.png)

## Colab
Chạy mã nguồn trên môi trường colab bằng [đường dẫn](https://colab.research.google.com/drive/1P1x4H7Zbmiis7cv6ggHHxrlUqzJAvoKf?usp=sharing).

Nhóm có thực hiện giải thích mã nguồn [tại đây](https://github.com/quangdzuytran/DualAST/blob/main/explain/README.md)

## Requirements  
Môi trường để chạy mã nguồn:  
- python 3.7
- tensorflow 1.14.0
- CUDA 10.1
- PIL, numpy, scipy
- tqdm
  
## Model Training  
- Download the content dataset: [Places365(105GB)](http://data.csail.mit.edu/places/places365/train_large_places365standard.tar).
- Download the style dataset: [Artworks of Different Artists](https://drive.google.com/drive/folders/1WxWxIhqqtkx4CwBVem7ZSr_ay9JJCiOh?usp=sharing). Thanks for the dataset provided by [AST](https://github.com/CompVis/adaptive-style-transfer).
- Download the pre-trained [VGG-19](https://drive.google.com/drive/folders/1n7VazSzdVdAN8Bp392KYQGVshg9pTdQ4?usp=sharing) model, and record the path of VGG-19 in *vgg19.py*.
- Cài đặt GPU ID (nếu có) ở dòng 185 trong ‘main.py’.
- Chạy câu lệnh sau:
```
python main.py --model_name van-gogh \
               --phase train \
               --image_size 768 \
               --ptad /disk1/chb/data/vincent-van-gogh_road-with-cypresses-1890 \
               --ptcd /disk1/chb/data/data_large
```

## Model Inference
- Đặt mô hình trong thư mục *./models/*.
- Đặt ảnh nội dung trong thư mục *./images/content/* folder.
- Put some reference images to *./images/reference/* folder.
- Cài đặt GPU ID (nếu có) ở dòng 185 trong ‘main.py’.
- Chạy câu lịnh sau:
```
python main.py --model_name=van-gogh \
               --phase=inference \
               --image_size=1280 \
               --ii_dir images/content/ \
               --reference images/reference/van-gogh/1.jpg \
               --save_dir=models/van-gogh/inference \
               --ckpt_nmbr=300000
```
![image](https://github.com/HalbertCH/DualAST/blob/main/results/2.png) 
  
Tải về pre-trained models [link](https://drive.google.com/drive/folders/1n7VazSzdVdAN8Bp392KYQGVshg9pTdQ4?usp=sharing).  
  
## Model Testing
Tính deception rate của mô hình:
- Tải các ảnh để tính deception rate như trong file [eval_paths_700_val](https://github.com/quangdzuytran/DualAST/blob/main/evaluation/evaluation_data/eval_paths_700_val.json).
- Chạy `./download_evaluation_data.py` để tải weight của mô hình phân loại.
- Đặt biến `results_dir` trong `eval_deception_score.py:92` thành đường dẫn của ảnh được truyền phong cách.
Tất cả ảnh được phát sinh cùng một phương pháp phải nằm chung một thư mục.
- Chạy câu lệnh `./run_deception_score_vgg_16_wikiart.sh`.
- Đọc kết quả trong file log phát sinh.

## Comparison Results
Hình ảnh so sánh DualAST với [Gatys *et al.*](https://github.com/anishathalye/neural-style), [AdaIN](https://github.com/naoto0804/pytorch-AdaIN), [WCT](https://github.com/eridgd/WCT-TF), [Avatar-Net](https://github.com/LucasSheng/avatar-net), [SANet](https://github.com/GlebBrykin/SANET), [AST](https://github.com/CompVis/adaptive-style-transfer), và [Svoboda *et al.*](https://github.com/nnaisense/conditional-style-transfer).  
  
![image](https://github.com/HalbertCH/DualAST/blob/main/results/3.png)  

## Acknowledgments
Mà nguồn này được fork từ mã nguồn của nhóm tác giả [DualAST](https://github.com/HalbertCH/DualAST). Được bổ sung và cài đặt thêm phần evaluation dựa theo [link](https://github.com/CompVis/adaptive-style-transfer/tree/master/evaluation).

Mà nguồn được dựa vào [AST](https://github.com/CompVis/adaptive-style-transfer). Xin cảm ơn vì bài báo và mã nguồn của họ.
