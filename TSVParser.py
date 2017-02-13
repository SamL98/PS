f = open('counterbalancing2.tsv', 'r')
title_out = open('titles.txt', 'w')
article_out = open('articles.txt', 'w')

def parse_file(f, t_out, a_out):
	first_line = True
	for line in f:
		if first_line:
			first_line = False
		else:
			words = line.split('\t')
			title = words[7] + '*****'
			content = words[8] + '*****'
			t_out.write(title)
			t_out.write(title)
			a_out.write(content)
			a_out.write(content)

	f.close()

parse_file(f, title_out, article_out)

article_out.close()
title_out.close()