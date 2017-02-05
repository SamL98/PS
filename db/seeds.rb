# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
count = 0
tmp_count = 0

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
	"L12"
]

candidates = [
	"James Walker", 
	"Scott Taylor", 
	"Steven Moore", 
	"Thomas Clark", 
	"Brian Miller", 
	"Robert Harris",
	"Peter Brown",
	"Roger Lewis"
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

while count < titles.count
	title = titles[count]
	article = articles[count]

	condition = conditions[count/32]
	candidate = candidates[count/16]
	templates = [template_sets[0][tmp_count], template_sets[1][tmp_count]]

	art = Article.new(
		candidate: candidate, 
		title: title, text: article,
		index: count, rand_index: 0,
		condition: condition,
		template: templates[0]
		)

	count += 1
	
	sym = templates[1].to_sym
	neutral = Article.new(
		candidate: candidate, 
		title: neutral_pages[sym][0], text: neutral_pages[sym][1],
		index: count, rand_index: 0,
		condition: condition,
		template: templates[1]
		)

	art.save
	neutral.save

	count += 1
	tmp_count += 1
	if tmp_count == 16
		tmp_count = 0
	end
end
