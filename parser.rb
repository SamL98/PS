require 'active_record'
require 'Rails'

config = Rails::Application::Configuration.new
#host = config.database_configuration[Rails.env]["host"]
#print host
#username = config.database_configuration[Rails.env]["username"]
#password = config.database_configuration[Rails.env]["password"]

ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: 'db/production.sqlite3',
)


Subject.all.each do |subj|
    subj.visits.all.each do |visit|
        if !visit.index.nil?
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