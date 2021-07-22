#!/bin/sh

# Tách riêng 6 triệu titles đầu tiên
# split -l6000000 ../data/news_titles.txt news_titles

# Tách cụm âm tiết tiếng Việt theo dòng
# ./bin/telexify news_titles.aa news_titles.aa.xyz

# - - -

# Thử N-gram với https://kheafield.com/code/kenlm
# ./bin/lmplz -o 4 --text news_titles.aa.xyz --arpa news_titles.xyz.arpa # counting

# Read Probing at https://kheafield.com/code/kenlm/structures
# ./bin/build_binary -p 1.5 probing news_titles.xyz.arpa news_titles.xyz.binary 

./bin/query -n -v summary -v sentence -v word news_titles.xyz.binary <query.txt
