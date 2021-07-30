words = File.open("dict.parts.xyz").read.split("\n").uniq
 
words_pieces = words.map{ |w| w.split(" ").sort.join(" ") }
uniq_wps = words_pieces.uniq
dup_wps = words_pieces - uniq_wps

dup_wps = []
wps = words_pieces.sort
wps.each_with_index do |wp, i|
	if (wp == wps[i + 1])
		dup_wps << wp
	end
end

dup_wps.uniq!
puts dup_wps.size
# puts dup_wps

tmp = []
words_pieces.each_with_index do |wp, i|
	if (dup_wps.include?(wp))
		 tmp << "#{wp} => #{words[i]}"
	end
end

dup_words = tmp.sort
count = 0
dup_words.each_with_index do |dw, i|
	puts dw
	count += 1
	if (dw.split("=>")[0] != dup_words[i+1].to_s.split("=>")[0])
		puts count
		count = 0
	end
end