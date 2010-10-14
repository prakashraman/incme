# SIMPLE SITE MAKER

Simple Site Maker is a tool that eliminates the repetition of code when you have to create static HTML pages.

### USAGE

ruby simple-site-maker.rb --source-dir=<path-to-source-dir> --dest-dir=<path-to-dest-dir>

source-dir : The directory that contains the html pages and the include pages
dest-dir: The directory to be created with the generated pages

### HOW IT WORKS

All the pages are parsed through for the [[inc: <include_file_name>]] tag and that tag is replaced with the contents of the include_file. Thats it !

include_file: the include file needs to be available at <source-dir>/_includes/<include_file_name>

Note: currently js, exe, gif, png, jpeg files are not parsed

### SOURCE FOLDER STRUCTURE

|- _includes_
|- <remaining files>
\- <remaining files>

_includes_ : This folder must contain all the include_files that can be accessed via [[inc: <include_file_name>]]

### EXAMPLE

source 
|- _includes_
   |- header
   \- footer
|- index.html
\- logo.png

header: (include)
-----------------
<html>
<head>
 <title>Simple Site Maker</title>
<head>
<body>

footer: (include)
-----------------
</body>
</html>

index.html
----------
[[inc: header]]
<img src="logo.png">
Hello World
[[inc: footer]]

ruby simple-site-maker.rb --source-dir=source --dest-dir=gen

"gen" folder is created with "index.html" in it

generated index.html
---------------------
<html>
<head>
 <title>Simple Site Maker</title>
<head>
<body>
<img src="logo.png">
Hello World
</body>
</html>


Thats it !