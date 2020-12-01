import xml.etree.ElementTree as ET
import pyaml
import dateutil.parser
import sys

OUT_DIR = sys.argv[-1]
if not OUT_DIR:
    OUT_DIR = 'wiki-pages'

IN_FILE = sys.argv[-2]
if not IN_FILE:
    IN_FILE = 'municipalgreennewdealwiki_xml_28a25c181b5c3def26f0.xml'

tree = ET.parse(IN_FILE)
root = tree.getroot()
base_string = '{http://www.mediawiki.org/xml/export-0.11/}'

class Rev:
    timestamp = ''
    content = ''

    def __str__(self):
        return pyaml.dump(self.__dict__)

class Page:
    title = ""
    content = Rev()

    def __str__(self):
        dict_self = {
            'title': self.title,
            'content': str(self.content)
        }
        return pyaml.dump(dict_self)

def siteinfo(tree):
    pass

def newer_p(t1, t2):
    if not t2:
        return True
    return dateutil.parser.parse(t1) > dateutil.parser.parse(t2)

def paginate(tree):
    def revisionate(tree):
        rev = Rev()
        for child in tree:
            if child.tag == '{http://www.mediawiki.org/xml/export-0.11/}text':
                rev.content = child.text
            elif child.tag == '{http://www.mediawiki.org/xml/export-0.11/}timestamp':
                rev.timestamp = child.text

            if rev.content and rev.timestamp:
                return rev
        
    page = Page()

    for child in tree:
        if child.tag == '{http://www.mediawiki.org/xml/export-0.11/}title':
            page.title = child.text
        elif child.tag == '{http://www.mediawiki.org/xml/export-0.11/}ns':
            #don't know what this is; don't care
            continue
        elif child.tag == '{http://www.mediawiki.org/xml/export-0.11/}id':
            #don't know what this is; don't care
            continue
        elif child.tag == '{http://www.mediawiki.org/xml/export-0.11/}revision':
            content_maybe = revisionate(child)
            if content_maybe.content and newer_p(content_maybe.timestamp, page.content.timestamp):
                page.content = content_maybe
        else:
            print(child.tag)

    return page

for child in root:
    if child.tag == '{http://www.mediawiki.org/xml/export-0.11/}siteinfo':
        siteinfo(child)
    elif child.tag == '{http://www.mediawiki.org/xml/export-0.11/}page':
        page = paginate(child)
        open(f"{OUT_DIR}/{page.title.replace(' ', '-')}.mediawiki", 'w', encoding="utf-8").write(page.content.content)
    else:
        print(child.tag)
        raise Exception(f"is the {{}} encloded string {base_string}")