#!/bin/sh

# Tách riêng 6 triệu titles đầu tiên từ file gốc
# split -l6000000 ../data/news_titles.txt news_titles.
# Hoặc giải nén file news_titles.aa.7z

# Tách cụm âm tiết tiếng Việt theo dòng
./bin/telexify news_titles.aa news_titles.aa.xyz

# - - - - - - - - - - - - - - - - - - - - - - - - 
# Thử N-gram với https://kheafield.com/code/kenlm

./bin/lmplz -o 6 --prune 3 --text news_titles.aa.xyz --arpa news_titles.xyz.arpa

# Read Probing at https://kheafield.com/code/kenlm/structures
./bin/build_binary -p 1.5 probing news_titles.xyz.arpa news_titles.xyz.binary 

# Test với 1 câu từ tập news_titles.ab
# "Nhiều hệ lụy khôn lường từ việc làm giả thực phẩm chức năng."
./bin/query -v summary -v sentence -v word news_titles.xyz.binary <query.txt

# Tương tác sâu vơi với python binding
# pip3 install https://github.com/kpu/kenlm/archive/master.zip
python3 query.py
#
# Sent:
# ^nhieu|zf he|zj luy|j khon|z luong|wf tu|wf viec|zj lam|f gia|r thuc|wj pham|zr chuc|ws nang|w
# Score -20.317848205566406
# Perplexity 28.266684519165167
# 
# Words:
# -2.442754 2: <s> ^nhieu|zf
# -2.900222 3: <s> ^nhieu|zf he|zj
# -0.097574 4: <s> ^nhieu|zf he|zj luy|j
# -1.891647 3: he|zj luy|j khon|z
# -0.075841 4: he|zj luy|j khon|z luong|wf
# -1.171368 4: luy|j khon|z luong|wf tu|wf
# -1.503138 4: khon|z luong|wf tu|wf viec|zj
# -1.418109 3: tu|wf viec|zj lam|f
# -2.549577 3: viec|zj lam|f gia|r
# -3.840632 2: gia|r thuc|wj
# -0.472939 3: gia|r thuc|wj pham|zr
# -1.438572 3: thuc|wj pham|zr chuc|ws
# -0.001879 4: thuc|wj pham|zr chuc|ws nang|w
# -0.513599 5: thuc|wj pham|zr chuc|ws nang|w </s>

# KenLM tập trung scoring nhanh trên tập dữ liệu lớn (not fit ram)
# Để làm các tác vụ khác như predict next word, LM cho speech-to-text
# Cần viết bộ decoder riêng:
# https://github.com/kpu/kenlm#decoder-developers
# https://stackoverflow.com/questions/43841467/how-to-compute-perplexity-using-kenlm