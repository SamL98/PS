class SearchEngineController < ApplicationController
	def login
	end

	def home
		subj_id = params[:subj]
		condition = params[:cond]

		existing_id = 0

		Subject.all.each do |subj|
			if subj.identifier == subj_id
				existing_id = subj.id
				break
			end
		end

		if existing_id != 0
			subject = Subject.find(existing_id)
		else
			subject = Subject.new({identifier: subj_id, condition: condition})
			subject.save
		end

		@articles = Article.all
		session[:subj_id] = subject.id
		session[:condition] = subject.condition
	end

	def search
		query = params[:q]

		candidate = ""
		if(query != "")
			candidate = filter_search(query)
		end

		@articles = Article.where("candidate = ? AND condition = ?", candidate, session[:condition])

		#all_articles.each do |article|
		#	if article.candidate == candidate && article.condition == session[:condition]
		#		@articles << article
		#	end
		#end

		i = 1
		if(@articles.length > 0)
			@articles.shuffle!
			@articles.each do |art|
				art.update_attribute(:rand_index, i)
				i+= 1
			end
		end
	end

	def show
		id = params[:id].to_i
		articles = Article.all
		articles.each do |article|
			if article.index == id
				@article = article
			end
		end
	end

	def log
		id = session[:subj_id].to_i
		subject = Subject.find(id)
		@visit = subject.visits.create(visit_params)
		@visit.save
	end

	private 
	def visit_params
		visit = params["article"]
		{index: visit["index"], rand_index: visit["rand_index"], time_spent: visit["time_spent"]}
	end

	def filter_search(query)
		candidates = ["Patrick J. Fischer", "Michael J. Holbrook"]
		candidate = ""

		search_terms = query.split(" ")
		search_terms.each do |term|
			term.tr('!@#$%^&*()~`1234567890-=_+[][]|{};:\"\,./<>?', '')
			candidates.each do |cand|
				cand.split(" ").each do |word|
					if word.downcase.include? term.downcase
						candidate += cand
						return candidate
					end
					if term.downcase.include? word.downcase
						candidate += cand
						return candidate
					end
				end
			end
		end
	end
end
