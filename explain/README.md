# Giải thích code
- Đầu tiên chúng ta khởi tạo backbone là mô hình vgg-19 đã train trên tập ImageNet trong file [vgg19.py](https://github.com/quangdzuytran/DualAST/blob/main/vgg19.py)
- Trong file [img_augm.py](https://github.com/quangdzuytran/DualAST/blob/main/img_augm.py) thì ta có class [Augmentor](https://github.com/quangdzuytran/DualAST/blob/1dd1b4b52b910e25e1a807198e36174b6228c4b6/img_augm.py#L24-L186) gồm các phép làm tăng cường và biến đổi ảnh như rotation, flip, crop,...
- Trong file [prepare_dataset.py](https://github.com/quangdzuytran/DualAST/blob/main/prepare_dataset.py) có 2 class **ArtDataset** và **PlacesDataset**. Điểm khác nhau của 2 class này là class **PlacesDataset** lấy các ảnh trong từng loại địa điểm đúng theo format của tập dữ liệu. Còn **ArtDataset** đọc các ảnh trong thư mục truyền vào. Khi đọc dữ liệu ta truyền vào **Augmentor** để tăng cường và biến đổi hình ảnh.
	- [ArtDataset](https://github.com/quangdzuytran/DualAST/blob/cb159deb7638c5bb0544a8640c4704ffe683d00e/prepare_dataset.py#L29-L76): Dùng để đọc một batch các ảnh art trong một thư mục truyền vào.
	- [PlacesDataset](https://github.com/quangdzuytran/DualAST/blob/cb159deb7638c5bb0544a8640c4704ffe683d00e/prepare_dataset.py#L79-L156): Dùng để đọc một batch các ảnh của Places365 dataset trong một thư mục truyền vào.
- Trong file [ops.py](https://github.com/quangdzuytran/DualAST/blob/main/ops.py) ta cài đặt các lớp cần thiết cho mô hình như fully_connected, flatten,...
- Trong file [module.py](https://github.com/quangdzuytran/DualAST/blob/main/module.py) ta có:
	- [encoder](https://github.com/quangdzuytran/DualAST/blob/1dd1b4b52b910e25e1a807198e36174b6228c4b6/module.py#L23-L58) như đã được nêu trong paper, encoder bao gồm 1 stride-1 và 4 stride-2 lớp tích chập.
	- [decoder](https://github.com/quangdzuytran/DualAST/blob/1dd1b4b52b910e25e1a807198e36174b6228c4b6/module.py#L85-L146) bao gồm 9 khối residual, 4 khối upsampling, và 1 lớp tích chập.
	- [SCB](https://github.com/quangdzuytran/DualAST/blob/1dd1b4b52b910e25e1a807198e36174b6228c4b6/module.py#L61-L82) bao gồm 1 stride-1 và 2 stride-2 lớp tích chập.
	- [style discriminator](https://github.com/quangdzuytran/DualAST/blob/1dd1b4b52b910e25e1a807198e36174b6228c4b6/module.py#L149-L198) là một mạng tích chập với 7 lớp tích chập stride-2.
	- [feature discriminator](https://github.com/quangdzuytran/DualAST/blob/1dd1b4b52b910e25e1a807198e36174b6228c4b6/module.py#L201-L215) bao gồm 3 stride-2 lớp tích chập và 1 lớp fully connected.
	- Và các hàm loss dùng cho discriminator.
- Trong file [model.py](https://github.com/quangdzuytran/DualAST/blob/main/model.py) bao gồm class mô hình chính:
	- Đầu tiên là hàm [init](https://github.com/quangdzuytran/DualAST/blob/1cf6c2a8f3bddf65afbb09e2d7d7816c3a30545a/model.py#L37-L89) nơi ta định nghĩa tên mô hình, các đường dẫn để lưu checkpoint, logs,...
	- Hai hàm [save](https://github.com/quangdzuytran/DualAST/blob/1cf6c2a8f3bddf65afbb09e2d7d7816c3a30545a/model.py#L579-L589), [load](https://github.com/quangdzuytran/DualAST/blob/1cf6c2a8f3bddf65afbb09e2d7d7816c3a30545a/model.py#L591-L613) dùng để lưu và tải lại mô hình trong quá trình làm việc.
	- Hàm [_build_model](https://github.com/quangdzuytran/DualAST/blob/1cf6c2a8f3bddf65afbb09e2d7d7816c3a30545a/model.py#L91-L310) ta có 2 chế độ:
		- Trường hợp chúng ta đang huấn luyện mô hình [(giai đoạn offline)](https://github.com/quangdzuytran/DualAST/blob/1cf6c2a8f3bddf65afbb09e2d7d7816c3a30545a/model.py#L92-L288)
			- Từ dòng [94 - 101](https://github.com/quangdzuytran/DualAST/blob/1cf6c2a8f3bddf65afbb09e2d7d7816c3a30545a/model.py#L94-L101) chúng ta thiết lập các lớp input cho mô hình.
			- Từ dòng [105-131](https://github.com/quangdzuytran/DualAST/blob/1cf6c2a8f3bddf65afbb09e2d7d7816c3a30545a/model.py#L105-L131) ta ghép nối các khối (như encoder, decoder, discriminator) lại thành mô hình.
			- Từ dòng [135-215](https://github.com/quangdzuytran/DualAST/blob/1cf6c2a8f3bddf65afbb09e2d7d7816c3a30545a/model.py#L135-L215) ta định nghĩa các hàm loss như đã mô tả trong paper.
			- Từ dòng [218-242](https://github.com/quangdzuytran/DualAST/blob/1cf6c2a8f3bddf65afbb09e2d7d7816c3a30545a/model.py#L218-L242) ta cài đặt bước tối ưu để dùng trong quá trình huấn luyện mô hình.
			- Từ dòng [245-288](https://github.com/quangdzuytran/DualAST/blob/1cf6c2a8f3bddf65afbb09e2d7d7816c3a30545a/model.py#L246-L288) ta cài đặt để ghi quá trình huấn luyện vào tensorboard để theo dõi.
		- Trường hợp chúng ta dùng mô hình [(giai đoạn online)](https://github.com/quangdzuytran/DualAST/blob/1cf6c2a8f3bddf65afbb09e2d7d7816c3a30545a/model.py#L289-L310)
			- Cùng giống như quá trình huấn luyện nhưng không có các bước tính loss và tối ưu.
			- Từ dòng [292-298](https://github.com/quangdzuytran/DualAST/blob/1cf6c2a8f3bddf65afbb09e2d7d7816c3a30545a/model.py#L292-L298) là bước thiết lập các lớp input.
			- Từ dòng [302-309](https://github.com/quangdzuytran/DualAST/blob/1cf6c2a8f3bddf65afbb09e2d7d7816c3a30545a/model.py#L302-L310) ta ghép nối các khối lại thành mô hình.
	- Hàm [train](https://github.com/quangdzuytran/DualAST/blob/1cf6c2a8f3bddf65afbb09e2d7d7816c3a30545a/model.py#L313-L424) dùng để huấn luyện mô hình.
		- Từ dòng [315-322](https://github.com/quangdzuytran/DualAST/blob/1cf6c2a8f3bddf65afbb09e2d7d7816c3a30545a/model.py#L315-L322) là bước khởi tạo cho augmentor và class đọc dataset.
		- Từ dòng [326-340](https://github.com/quangdzuytran/DualAST/blob/1cf6c2a8f3bddf65afbb09e2d7d7816c3a30545a/model.py#L326-L340) ta đa luồng cho quá trình đọc dữ liệu.
		- Từ dòng [343-358](https://github.com/quangdzuytran/DualAST/blob/1cf6c2a8f3bddf65afbb09e2d7d7816c3a30545a/model.py#L343-L358) là các bước khởi tạo cho mô hình.
		- Từ dòng [360-424](https://github.com/quangdzuytran/DualAST/blob/1cf6c2a8f3bddf65afbb09e2d7d7816c3a30545a/model.py#L360-L424) là quá trình huấn luyện với mỗi step là một batch_size dữ liệu đầu vào. Trong đó [371-385](https://github.com/quangdzuytran/DualAST/blob/1cf6c2a8f3bddf65afbb09e2d7d7816c3a30545a/model.py#L371-L385) dùng để huấn luyện cho generator, [388-396](https://github.com/quangdzuytran/DualAST/blob/1cf6c2a8f3bddf65afbb09e2d7d7816c3a30545a/model.py#L388-L396) dùng để huấn luyên discriminator và [404-418](https://github.com/quangdzuytran/DualAST/blob/1cf6c2a8f3bddf65afbb09e2d7d7816c3a30545a/model.py#L404-L418) dùng để lưu mô hình tron quá trình huấn luyện.
	- Hàm [inference](https://github.com/quangdzuytran/DualAST/blob/1cf6c2a8f3bddf65afbb09e2d7d7816c3a30545a/model.py#L510-L577) là hàm chạy trong quá trình online.
		- Từ dòng [513-537](https://github.com/quangdzuytran/DualAST/blob/1cf6c2a8f3bddf65afbb09e2d7d7816c3a30545a/model.py#L513-L537) là quá trình init để cho các bước đọc ghi dữ liệu.
		- Từ dòng [539-575](https://github.com/quangdzuytran/DualAST/blob/1cf6c2a8f3bddf65afbb09e2d7d7816c3a30545a/model.py#L539-L575) với mỗi ảnh trong thư mục cần inference ta đọc ảnh đó lên, và ảnh phong cách lên sau đó truyền vào mô hình. Sau khi nhận output từ của mô hình ta tiến hành lưu ảnh đã được truyền phong cách lại.
- Trong file [main.py](https://github.com/quangdzuytran/DualAST/blob/main/main.py) gồm các quá trình để chạy mô hình, ta có thể chạy truyền các tham số và để hàm [main](https://github.com/quangdzuytran/DualAST/blob/1cf6c2a8f3bddf65afbb09e2d7d7816c3a30545a/main.py#L160-L182) thực hiện các bước như để huấn luyện hoặc inference mô hình.
- Quá trình [evaluation](https://github.com/quangdzuytran/DualAST/tree/main/evaluation)
	- Ta tải dữ liệu để đánh giá mô hình bao gồm dữ liệu trong 2 tập MSCOCO và Places365, ta chỉ cần dùng các ảnh được đề cập trong file [eval_paths_700_val.json](https://github.com/quangdzuytran/DualAST/blob/main/evaluation/evaluation_data/eval_paths_700_val.json). Ta có thể dùng hàm sau để copy các file cần dùng
	```python
	import ast
	import shutil
	from tqdm import *
	with open("/content/DualAST/evaluation/evaluation_data/eval_paths_700_val.json", "r") as f:
		filenames = ast.literal_eval("".join(f.readlines()))

	for file in tqdm(filenames):
		shutil.copy2(file, "/content/DualAST/images/validation/")
	```
	- Ta chạy file [download_evaluation_data.py](https://github.com/quangdzuytran/DualAST/blob/main/evaluation/download_evaluation_data.py) vì trong đây là code để chúng ta tải và giải mô hình wikiArt về để đánh giá.
	- Trong file [check_fc8_labels.py](https://github.com/quangdzuytran/DualAST/blob/main/evaluation/check_fc8_labels.py) chúng ta đọc dữ liệu từ 'evaluation_data/split.hdf5' để ánh xạ tên của phong cách nghệ thuật về output của mô hình wikiArt. Vì output của mô hình sau khi lấy argmax là các index của lớp được dự đoán chứ không phải tên của lớp đó.
	- Ta cài đặt một logger và lưu trong file [logger.py](https://github.com/quangdzuytran/DualAST/blob/main/evaluation/logger.py) để ghi log quá trình tính toán.
	- Trong [feature_extractor](https://github.com/quangdzuytran/DualAST/tree/main/evaluation/feature_extractor) là code mô hình dùng để đánh giá. Chúng ta load weight vgg16 được huyến huấn luyện trên wikiArt để đánh giá mô hình.
		- Trong file [image_getter.py](https://github.com/quangdzuytran/DualAST/blob/main/evaluation/feature_extractor/image_getter.py) là 2 class **ImageGetterFromMat** đọc hình ảnh từ định dạng mat. Và **ImageGetterFromPaths** để đọc các hình trong một dường dẫn.
		- Trong file [features.py](https://github.com/quangdzuytran/DualAST/blob/main/evaluation/feature_extractor/features.py) là các hàm để phụ trợ cho quá trình rút trích đặt trưng.
		- Trong file [feature_extractor.py](https://github.com/quangdzuytran/DualAST/blob/main/evaluation/feature_extractor/feature_extractor.py) là class **SlimFeatureExtractor** dựa theo cài đặt của mô hình để rút trích đặt trưng cho các ảnh trong một thư mục.
		- Trong [preprocessing](https://github.com/quangdzuytran/DualAST/tree/main/evaluation/feature_extractor/preprocessing) là các phép toán preprocessing dữ liệu như scrop, resize,...
		- Trong [nets](https://github.com/quangdzuytran/DualAST/tree/main/evaluation/feature_extractor/nets) là backbone của mô hình và một [nets_factory](https://github.com/quangdzuytran/DualAST/blob/main/evaluation/feature_extractor/nets/nets_factory.py) để chúng ta lựa chọn vgg16 hay vgg19
	- Trong file [eval_deception_score.py](https://github.com/quangdzuytran/DualAST/blob/main/evaluation/eval_deception_score.py) bao gồm main để tính toán chính và các hàm khác để phụ trợ.
		- Từ dòng [175-190](https://github.com/quangdzuytran/DualAST/blob/5d6d5970d687c9e40a5bab83aac0a39ccc7e0622/evaluation/eval_deception_score.py#L175-L190) là phần đầu của main. Ta khởi tạo các biến cần thiết cho quá trình tính toán như logger, extract (để rút trích đặt trưng),...
		- Từ dòng [192-198](https://github.com/quangdzuytran/DualAST/blob/5d6d5970d687c9e40a5bab83aac0a39ccc7e0622/evaluation/eval_deception_score.py#L192-L198) với mỗi phong cách nghệ thuật ta thực hiện hàm run để tính toán kết quả độ chính xác của mô hình classify.
		- Trong hàm [run](https://github.com/quangdzuytran/DualAST/blob/5d6d5970d687c9e40a5bab83aac0a39ccc7e0622/evaluation/eval_deception_score.py#L89-L104) ta thực hiện classify xem hình ảnh được truyền phong cách có được classify thành phong cách đó hay không. Với mô hình là extractor truyền vào mà cũng chính là mô hình được huấn luyện trên wikiArt.
		- Từ dòng [200-204](https://github.com/quangdzuytran/DualAST/blob/5d6d5970d687c9e40a5bab83aac0a39ccc7e0622/evaluation/eval_deception_score.py#L200-L204) là quá trình ta ghi log kết quả.
