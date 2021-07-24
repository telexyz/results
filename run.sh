#!/bin/sh

# Tách riêng 6 triệu titles đầu tiên từ file gốc
# split -l6000000 ../data/news_titles.txt news_titles.
# Hoặc giải nén file news_titles.aa.7z

# Tách cụm âm tiết tiếng Việt theo dòng
# ./bin/telexify news_titles.aa news_titles.dense.xyz dense
./bin/telexify news_titles.aa news_titles.spare.xyz spare

# - - - - - - - - - - - - - - - - - - - - - - - - 
# Thử N-gram với https://kheafield.com/code/kenlm

# ./bin/lmplz -o 6 --prune 3 --text news_titles.dense.xyz --arpa news_titles.dense.arpa
./bin/lmplz -o 11 --prune 3 --text news_titles.spare.xyz --arpa news_titles.spare.arpa

# Read Probing at https://kheafield.com/code/kenlm/structures
# ./bin/build_binary -p 1.5 probing news_titles.dense.arpa news_titles.dense.binary 
./bin/build_binary -p 1.5 probing news_titles.spare.arpa news_titles.spare.binary 

# Test với 1 câu từ tập news_titles.ab
# "Nhiều hệ lụy khôn lường từ việc làm giả thực phẩm chức năng."
# ./bin/query -v summary -v sentence -v word news_titles.dense.binary <query.dense.txt
./bin/query -n news_titles.spare.binary <query.spare.txt

# Tương tác sâu hơn với python binding, max_order=11
# pip3 install https://github.com/telexyz/kenlm/archive/master.zip
python3 query.py

# [ spare mode, 11-gram ]
# Sent: ^ nhieu zf he zj luy j khon z luong wf tu wf viec zj lam f gia r thuc wj pham zr chuc ws nang w
# Score -19.449417114257812
# Perplexity 4.950191952427405
# 
# Tokens:
# -0.233295 2: <s> ^
# -2.243072 3: <s> ^ nhieu
# -0.001996 4: <s> ^ nhieu zf
# -2.895364 5: <s> ^ nhieu zf he
# -0.001064 6: <s> ^ nhieu zf he zj
# -0.060517 7: <s> ^ nhieu zf he zj luy
# -0.000008 8: <s> ^ nhieu zf he zj luy j
# -2.423051 5: he zj luy j khon
# -0.023709 6: he zj luy j khon z
# -0.097924 7: he zj luy j khon z luong
# -0.000708 8: he zj luy j khon z luong wf
# -0.750089 9: he zj luy j khon z luong wf tu
# -0.003269 10: he zj luy j khon z luong wf tu wf
# -1.373894 8: j khon z luong wf tu wf viec
# -0.000000 9: j khon z luong wf tu wf viec zj
# -1.359969 6: wf tu wf viec zj lam
# -0.069881 6: tu wf viec zj lam f
# -2.119208 5: viec zj lam f gia
# -0.346954 6: viec zj lam f gia r
# -3.352437 4: f gia r thuc
# -0.084069 5: f gia r thuc wj
# -0.355494 6: f gia r thuc wj pham
# -0.000283 7: f gia r thuc wj pham zr
# -1.228442 6: r thuc wj pham zr chuc
# -0.000803 7: r thuc wj pham zr chuc ws
# -0.001524 8: r thuc wj pham zr chuc ws nang
# -0.000022 9: r thuc wj pham zr chuc ws nang w
# -0.422367 10: r thuc wj pham zr chuc ws nang w </s>

# [ dense mode, 06-gram ]
# Sent: ^nhieu|zf he|zj luy|j khon|z luong|wf tu|wf viec|zj lam|f gia|r thuc|wj pham|zr chuc|ws nang|w
# Score -20.317848205566406
# Perplexity 28.266684519165167
# 
# Tokens:
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

# - - - - - - - - - - - - - - - - - - - - - - - - 
# KenLM tập trung train & score nhanh trên tập dữ liệu lớn (not fit ram). 
# Để làm các tác vụ khác như predict next word cần viết bộ decoder riêng
# Example https://github.com/jp-myk/lm-decoder

# git clone https://github.com/telexyz/lm-decoder.git
# brew install automake # autoconfig libtool
# cd lm-decoder
# make
# make lmdecoder
# ./bin/lmdecoder
# echo "平城京は奈良時代" | ./bin/lmdecoder sample_data/sample.dic sample_data/sample.5gram.arpa
# ======== N-BEST =========
# 1-best	平城京:ヘイジョウキョウ は:ハ 奈良:ナラ 時代:ジダイ	-9.3222
# 2-best	平城:ヒラジロ 京:ミヤコ は:ハ 奈良:ナラ 時代:ジダイ	-11.7875
# 3-best	平城:ヒラジロ 京:キョウ は:ハ 奈良:ナラ 時代:ジダイ	-13.2098
