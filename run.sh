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
