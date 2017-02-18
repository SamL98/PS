# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
title_path = Rails.root.join('titles.txt').to_s
art_path = Rails.root.join('articles.txt').to_s
title_in = File.open(title_path, 'r')
art_in = File.open(art_path, 'r')

titles = title_in.read.split('*****')
articles = art_in.read.split('*****')

conditions = [
	"M11",
	"M12",
	"L11",
	"L12",
	"M21",
	"M22",
	"L21",
	"L22",
	"L31",
	"L32",
	"M31",
	"M32",
	"L41",
	"L42",
	"M41",
	"M42"
]

candidates = [
	["James Walker", "David Walker"], 
	["Scott Taylor", "Jerry Taylor"], 
	["Steven Moore", "Ronald Moore"], 
	["Thomas Clark", "Walter Clark"], 
	["Brian Miller", "Larry Miller"], 
	["Robert Harris", "George Harris"],
	["Peter Brown", "Henry Brown"],
	["Roger Lewis", "Keith Lewis"]
]

template_sets = [
	[
		"TheBusinessJournal",
		"TheHerald",
		"TheReview",
		"TheEnquirer",
		"TheAdvocate",
		"TheTribune",
		"TheGazette",
		"TheUnionTimes",
		"TheAdvocate",
		"TheTribune",
		"TheGazette",
		"TheUnionTimes",
		"TheBusinessJournal",
		"TheHerald",
		"TheReview",
		"TheEnquirer"
	],
	[
		"Whitepages",
		"PeopleFinder",
		"spokeo",
		"zoominfo",
		"USSearch",
		"PeopleGuide",
		"intelius",
		"PeopleSmart",
		"USSearch",
		"PeopleGuide",
		"intelius",
		"PeopleSmart",
		"Whitepages",
		"PeopleFinder",
		"spokeo",
		"zoominfo"
	]
]

def createArticles(count, cand, title, text, cond, code, reality, templates)
	neutral_pages = {
		Whitepages: ["Whitepages Premium", "Your background report is ready..."],
		PeopleFinder: ["PeopleFinder", "Select an option to view results for..."],
		spokeo: ["SPOKEO", "We found information on..."],
		zoominfo: ["Zoominfo", "Here's what we found..."],
		USSearch: ["USSearch", "Get the information you need on..."],
		PeopleGuide: ["PeopleGuide", "PeopleGuide information on..."],
		intelius: ["Intelius", "Get the information you need on..."],
		PeopleSmart: ["PeopleSmart", "Select an option to view results for..."],
	}

	art = Article.new(
		candidate: cand, 
		title: title, text: text,
		index: count, rand_index: 0,
		condition: cond,
		neutrality: code, is_lure: reality,
		template: templates[0]
		)
	art.save()

	sym = templates[1].to_sym
	neutral = Article.new(
		candidate: cand, 
		title: neutral_pages[sym][0], text: neutral_pages[sym][1],
		index: count + 1, rand_index: 0,
		condition: cond,
		neutrality: 0, is_lure: reality,
		template: templates[1]
		)
	neutral.save()
end

count = 0
tmp_count = 0

pos_counter = 0
lure_counter = 0

is_pos = false
is_lure = false

while count < titles.count
	title = titles[count]
	article = articles[count]

	cond_count = count/32
	conds = [conditions[cond_count], conditions[cond_count + 4], conditions[cond_count + 8], conditions[cond_count + 12]]

	candidate_set = candidates[count/16]
	templates = [template_sets[0][tmp_count], template_sets[1][tmp_count]]

	code = 0

	if count > 7
		pos_counter += 1
		if is_pos
			code = 1
		else
			code = 2
		end
	else
		code = 1
	end

	createArticles(count, candidate_set[0], title, article, conds[0], code, is_lure, templates)
	createArticles(count + 128, candidate_set[1], title, article, conds[1], code, !is_lure, templates)
	createArticles(count + 256, candidate_set[0], title, article, conds[2], code, is_lure, templates)
	createArticles(count + 384, candidate_set[1], title, article, conds[3], code, !is_lure, templates)

	count += 2

	tmp_count += 1
	if tmp_count == 16
		tmp_count = 0
	end

	if pos_counter == 8
		is_pos = !is_pos
		pos_counter = 0
	end

	lure_counter += 1
	if lure_counter == 4
		is_lure = !is_lure
		lure_counter = 0
	end
end

RandomFlag.new(flag: true, ordering: "").save()
