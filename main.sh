infile=$1
wikiArchive=tmp/wiki.xml
pagesDir=tmp/wiki-pages
htmlDir=tmp/wiki-ugly-html
vueDir=pages
vuePrelude=src/vuePrelude.txt
vuePostlude=src/vuePostlude.txt

for requiredDir in tmp $pagesDir $htmlDir $vueDir
do
	mkdir $requiredDir 2> /dev/null
done

gunzipInfile() {
	gzippedWiki=$1
	outfile=$2
	gunzip < $gzippedWiki > $outfile
	mv $gzippedWiki tmp
}

genVueFile() {
	htmlFile=$1
	vueFile=$2
	cat $vuePrelude >> $vueFile
	cat $htmlFile >> $vueFile
	cat $vuePostlude >> $vueFile
}

convertToVue() {
	pagesDir=$1
	vueDir=$2
	for page in `ls $pagesDir`
	do
		baseFileName="${page%.*}"
		mediawikiFile="${pagesDir}/${page}"
		htmlFile="${htmlDir}/${baseFileName}.html"
		vueFile="${vueDir}/${baseFileName}.vue"
		pandoc -f mediawiki -t html < $mediawikiFile > $htmlFile
		# TODO deFuck
		genVueFile $htmlFile $vueFile
	done
}

main() {
	gunzipInfile $infile $wikiArchive
	# each file is the most recent revision of a wiki page
	python src/parse-xml-into-pages.py $wikiArchive $pagesDir
	# converts the mediawiki pages to vue pages that can be plugged directly into the website
	convertToVue $pagesDir $vueDir
}

main
