infile=$1
wikiArchive=tmp/wiki.xml
pagesDir=tmp/wiki-pages
htmlDir=tmp/wiki-ugly-html

for requiredDir in tmp $pagesDir $htmlDir
do
	mkdir $requiredDir 2> /dev/null
done

gunzipInfile() {
	gzippedWiki=$1
	outfile=$2
	gunzip < $gzippedWiki > $outfile
	mv $gzippedWiki tmp
}

convertToVue() {
	pagesDir=$1
	for page in `ls $pagesDir`
	do
		mediawikiFile="${pagesDir}/${page}"
		htmlFile="${htmlDir}/${page}.html"
		echo $mediawikiFile
		pandoc -f mediawiki -t html < $mediawikiFile > $htmlFile
		# deFuck
		# add vue cruft
	done
}

main() {
	#gunzipInfile $infile $wikiArchive
	# # each file is the most recent revision of a wiki page
	python src/parse-xml-into-pages.py $wikiArchive $pagesDir
	convertToVue $pagesDir
}

main
