# Giải thích code
- Đầu tiên chúng ta khởi tạo backbone là mô hình vgg-19 đã train trên tập ImageNet trong file [vgg19.py](https://github.com/quangdzuytran/DualAST/blob/main/vgg19.py)
- Trong file [prepare_dataset.py](https://github.com/quangdzuytran/DualAST/blob/main/prepare_dataset.py) có 2 class **ArtDataset** và **PlacesDataset**. Điểm khác nhau của 2 class này là class **PlacesDataset** lấy các ảnh trong từng loại địa điểm đúng theo format của tập dữ liệu. Còn **ArtDataset** đọc các ảnh trong thư mục truyền vào.
	- [ArtDataset](https://github.com/quangdzuytran/DualAST/blob/cb159deb7638c5bb0544a8640c4704ffe683d00e/prepare_dataset.py#L29-L76): Dùng để đọc một batch các ảnh art trong một thư mục truyền vào.
	- [PlacesDataset](https://github.com/quangdzuytran/DualAST/blob/cb159deb7638c5bb0544a8640c4704ffe683d00e/prepare_dataset.py#L79-L156): Dùng để đọc một batch các ảnh của Places365 dataset trong một thư mục truyền vào.

