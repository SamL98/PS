for f in app/views/search_engine/*; do 
	cat $f | grep https://rawgit >> urls.txt
done

awk '{print substr($0, index($0, "href="), length($0))}' urls.txt
