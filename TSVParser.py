f = open('counterbalancing2.tsv', 'r')
title_out = open('titles.txt', 'w')
article_out = open('articles.txt', 'w')

first_line = True
for line in f:
	if first_line:
		first_line = False
	else:
		words = line.split('\t')
		title = words[7] + '*****'
		content = words[8] + '*****'
		title_out.write(title)
		title_out.write(title)
		article_out.write(content)
		article_out.write(content)

f.close()
title_out.close()
article_out.close()