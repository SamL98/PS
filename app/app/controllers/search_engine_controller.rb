class SearchEngineController < ApplicationController
	def login
	end

	def home
		@subj_id = params[:subj].to_s
		@condition = params[:cond].to_s

		subject = Subject.where("identifier = ?", @subj_id)
		if subject.length == 0
			Subject.new(identifier: @subj_id).save()
		end

		RandomFlag.first.update_attribute(:flag, true)
		RandomFlag.first.update_attribute(:ordering, "")
	end

	def search
		query = params[:q].to_s
		condition = params[:c].to_s
		@subj_id = params[:subj_id].to_s
		@cond = condition
		@query = query

		gon.subjId = @subj_id
		gon.cond = @cond
		gon.isLure = false
		gon.code = 0
		gon.cand = ""

		candidates = []
		case condition
		when 'M11'
			candidates = ["James Walker", "Scott Taylor"]
		when 'M21'
			candidates = ["David Walker", "Jerry Taylor"]
		when 'L31'
			candidates = ["James Walker", "Scott Taylor"]
		when 'L41'
			candidates = ["David Walker", "Jerry Taylor"]
		when 'M12'
			candidates = ["Steven Moore", "Thomas Clark"]
		when 'M22'
			candidates = ["Ronald Moore", "Walter Clark"]
		when 'L32'
			candidates = ["Steven Moore", "Thomas Clark"]
		when 'L42'
			candidates = ["Ronald Moore", "Walter Clark"]
		when 'L11'
			candidates = ["Brian Miller", "Robert Harris"]
		when 'L21'
			candidates = ["Larry Miller", "George Harris"]
		when 'M31'
			candidates = ["Brian Miller", "Robert Harris"]
		when 'M41'
			candidates = ["Larry Miller", "George Harris"]
		when 'L12'
			candidates = ["Peter Brown", "Roger Lewis"]
		when 'L22'
			candidates = ["Henry Brown", "Keith Lewis"]
		when 'M32'
			candidates = ["Peter Brown", "Roger Lewis"]
		when 'M42'
			candidates = ["Henry Brown", "Keith Lewis"]
		end

		candidate = ""
		if query != ""
			candidate = filter_search(candidates, query)
		end
		@cand = candidate

		articles = Article.where("candidate = ? AND condition = ?", candidate, condition)

		if RandomFlag.first.flag
			order_string = ""
			i = 1
			if articles != nil && articles.length > 0
				articles = articles.shuffle
				articles.each do |art|
					art.update_attribute(:rand_index, i)
					order_string += (i - 1).to_s + " "
					i += 1
				end
			end
			RandomFlag.first.update_attribute(:flag, false)
			RandomFlag.first.update_attribute(:ordering, order_string)
		else
			tmp = []
			i = 0
			RandomFlag.first.ordering.split(" ").each do |index|
				tmp[i] = articles[index.to_i]
				i += 1
			end
			articles = tmp
		end

		if articles.length > 0 
			@articles = articles
		end
	end

	def show
		indeces = RandomFlag.first.ordering.split(" ")
		indeces = indeces.shuffle

		order_string = ""
		indeces.each do |index|
			order_string += index + " "
		end
		RandomFlag.first.update_attribute(:ordering, order_string)

		id = params[:id].to_i
		condition = params[:cond].to_s
		@subj_id = params[:subj_id].to_s

		gon.cand = params[:cand].to_s
		gon.subjId = @subj_id
		gon.cond = condition

		Article.all.each do |article|
			if article.index == id && article.condition == condition
				@article = article
			end
		end

		gon.title = @article.title
		gon.text = @article.text
		gon.index = @article.index
		gon.randIndex = @article.rand_index
		gon.isLure = @article.is_lure
		gon.code = @article.neutrality

		render @article.template
	end

	def log
		identifier = params["subj_id"]

		puts 'LOGGING VISIT FOR ' + identifier.upcase
		subject = Subject.where("identifier = ?", identifier).first
		@visit = subject.visits.create(visit_params)
		puts @visit.index
		puts @visit.candidate
		@visit.save
	end

	def parse_data
		original_stdout = $stdout.clone
		$stdout = File.new(params[:filename].to_s + '.csv', 'w')
		Subject.all.each do |subj|
			subj.visits.all.each do |visit|
				if !visit.index.nil?
					print subj.identifier
					print ','
					print visit.candidate
					print ','
					print visit.condition
					print ','
					print visit.lure
					print ','
					print visit.code
					print ','
					print visit.index
					print ','
					print visit.rand_index
					print ','
					print visit.time_spent
					print ','
					print visit.created_at
					if visit.candidate.length > 0
						print ','
						articles = Article.where("candidate = ? AND condition = ?", visit.candidate, visit.condition)
						articles.all.each do |art|
							if art.index == visit.index
								puts art.title
							end
						end
					else
						puts ''
					end
				end
			end
		end
		$stdout = original_stdout
		puts 'affirm stdout back to normal'
	end

	private 
	def visit_params
		visit = params["article"]
		{index: visit["index"], rand_index: visit["rand_index"], time_spent: visit["time_spent"],
			candidate: visit["cand"], condition: visit["cond"], lure: visit["lure"], code: visit["code"]}
	end

	def filter_search(candidates, query)
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
		return candidate
	end

end
