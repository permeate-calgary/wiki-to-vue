# wiki-conversion software

## STEP ONE: Download the wiki source

'Special Pages' > 'Data and tools' > 'DataDump'

'Dump Type': xml > Delete
'Generate': xml > Submit

take your dump, save it here

maybe donate to Miraheze cuz hosting a wiki ain't free

## STEP TWO: run this on it

sh main.sh $nameOfDump

that'll output a directory called `pages`; move the *contents* of that into the `pages` directory of the vue site to update it.

run `src/sus.sed` on the pages if you're generating for the UN Sustainable Development Goals site.

## STEP THREE: refresh the site

move the pages into the repo and push it to github/lab. zeit will hook into that and regenerate the website.

## OTHER STUFF
repos:
  website source:
    - https://github.com/permeate-calgary/sustainable-development-website
    - https://gitlab.com/aljedaxi/gnd-doc-website
  other stuff:
    - https://gitlab.com/permeate_it_nerds/municipal-green-new-deal/wiki_to_pdf

LAST DUMP AT `01:50, 6 December 2019`
