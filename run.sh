#!/bin/sh

# Chuẩn bị dữ liệu
7z x news_titles.aa.7z
# 7z x news_titles.ab.7z
# cat news_titles.aa news_titles.bb > news_titles.txt
# - - - - - - - - - - - - - - - - - - - - - - - - 
# Tách cụm âm tiết tiếng Việt theo dòng
# mkdir -p data && ./bin/telexify news_titles.aa news_titles.dense.xyz dense
# - - - - - - - - - - - - - - - - - - - - - - - - 
# Thử N-gram với https://kheafield.com/code/kenlm
# ./bin/lmplz -o 6 --prune 3 --text news_titles.dense.xyz --arpa news_titles.dense.arpa
# ./bin/build_binary -p 1.5 probing news_titles.dense.arpa news_titles.dense.binary 
# - - - - - - - - - - - - - - - - - - - - - - - - 
# Test với 1 câu từ tập news_titles.ab
# "Nhiều hệ lụy khôn lường từ việc làm giả thực phẩm chức năng."
# ./bin/query -v summary -v sentence -v word news_titles.dense.binary <query.dense.txt
# - - - - - - - - - - - - - - - - - - - - - - - - 
# Tương tác sâu hơn với python binding, max_order=11
# pip3 install https://github.com/telexyz/kenlm/archive/master.zip
# python3 query.py

mkdir -p data && ./bin/telexify news_titles.aa news_titles.dense.xyz dense ngram
./bin/lmplz -o 4 --prune 3 --text news_titles.dense.xyz --arpa news_titles.dense.arpa
./bin/build_binary -p 1.5 probing news_titles.dense.arpa news_titles.dense.binary 
./bin/query -v summary -v sentence -v word news_titles.dense.binary <query.dense.txt
python3 query.dense.py

# [ dense mode, 04-gram ]
# Sent: nhieu|zf he|zj luy|j khon|z luong|wf tu|wf viec|zj lam|f gia|r thuc|wj pham|zr chuc|ws nang|w
# Score -29.399736404418945
# Perplexity 125.88708339515873
# 
# Tokens:
# -2.928498 2: <s> nhieu|zf
# -2.422586 3: <s> nhieu|zf he|zj
# -2.314583 3: nhieu|zf he|zj luy|j
# -3.797202 1: khon|z
# -1.783936 2: khon|z luong|wf
# -2.563290 2: luong|wf tu|wf
# -2.349796 2: tu|wf viec|zj
# -1.760662 3: tu|wf viec|zj lam|f
# -2.449651 3: viec|zj lam|f gia|r
# -2.987837 2: gia|r thuc|wj
# -1.456456 2: thuc|wj pham|zr
# -2.067834 3: thuc|wj pham|zr chuc|ws
# -0.012448 4: thuc|wj pham|zr chuc|ws nang|w
# -0.504956 4: pham|zr chuc|ws nang|w </s>

mkdir -p data && ./bin/telexify news_titles.aa news_titles.spare.xyz spare
./bin/lmplz -o 9 --prune 3 --text news_titles.spare.xyz --arpa news_titles.spare.arpa
./bin/build_binary -p 1.5 probing news_titles.spare.arpa news_titles.spare.binary 
./bin/query -n news_titles.spare.binary <query.spare.txt
python3 query.spare.py

# Sent: ^ nhieu zf he zj luy j khon z luong wf tu wf viec zj lam f gia r thuc wj pham zr chuc ws nang w
# Score -19.285001754760742
# Perplexity 4.883712198532233
# 
# Tokens:
# -0.237238 2: <s> ^
# -2.242908 3: <s> ^ nhieu
# -0.001996 4: <s> ^ nhieu zf
# -2.895337 5: <s> ^ nhieu zf he
# -0.001065 6: <s> ^ nhieu zf he zj
# -0.060517 7: <s> ^ nhieu zf he zj luy
# -0.000008 8: <s> ^ nhieu zf he zj luy j
# -2.422647 5: he zj luy j khon
# -0.023717 6: he zj luy j khon z
# -0.097922 7: he zj luy j khon z luong
# -0.000709 8: he zj luy j khon z luong wf
# -0.693922 9: he zj luy j khon z luong wf tu
# -0.000814 9: zj luy j khon z luong wf tu wf
# -1.373925 8: j khon z luong wf tu wf viec
# -0.000000 9: j khon z luong wf tu wf viec zj
# -1.360079 6: wf tu wf viec zj lam
# -0.069884 6: tu wf viec zj lam f
# -2.119284 5: viec zj lam f gia
# -0.346625 6: viec zj lam f gia r
# -3.351926 4: f gia r thuc
# -0.084040 5: f gia r thuc wj
# -0.355552 6: f gia r thuc wj pham
# -0.000284 7: f gia r thuc wj pham zr
# -1.228513 6: r thuc wj pham zr chuc
# -0.000803 7: r thuc wj pham zr chuc ws
# -0.001524 8: r thuc wj pham zr chuc ws nang
# -0.000010 9: r thuc wj pham zr chuc ws nang w
# -0.313749 9: thuc wj pham zr chuc ws nang w </s>

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

# Try another dataset
mkdir -p data && ./bin/telexify wikipedia.txt wikipedia.dense.xyz dense ngram
./bin/lmplz -o 4 --prune 3 --text news_titles.dense.xyz --arpa wikipedia.dense.arpa
./bin/build_binary -p 1.5 probing wikipedia.dense.arpa wikipedia.dense.binary 
./bin/query -v summary -v sentence -v word wikipedia.dense.binary <query.dense.txt
python3 query.wikipedia.dense.py

# Sent: nhieu|zf he|zj luy|j khon|z luong|wf tu|wf viec|zj lam|f gia|r thuc|wj pham|zr chuc|ws nang|w
# Score -29.399736404418945
# Perplexity 125.88708339515873
# 
# Tokens:
# -2.928498 2: <s> nhieu|zf
# -2.422586 3: <s> nhieu|zf he|zj
# -2.314583 3: nhieu|zf he|zj luy|j
# -3.797202 1: khon|z
# -1.783936 2: khon|z luong|wf
# -2.563290 2: luong|wf tu|wf
# -2.349796 2: tu|wf viec|zj
# -1.760662 3: tu|wf viec|zj lam|f
# -2.449651 3: viec|zj lam|f gia|r
# -2.987837 2: gia|r thuc|wj
# -1.456456 2: thuc|wj pham|zr
# -2.067834 3: thuc|wj pham|zr chuc|ws
# -0.012448 4: thuc|wj pham|zr chuc|ws nang|w
# -0.504956 4: pham|zr chuc|ws nang|w </s>