$stdout = File.new('final_output.csv')

Subject.all.each do |subj|
    subj.visits.all.each do |visit|
        if visit.index >= 0
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
            else
                puts ''
            end
        end
    end
end