# SIMPLE SITE MAKER

Simple Site Maker is a tool that eliminates the repetition of code when you have to create static HTML pages.

### USAGE

<code>
    $ ruby simple-site-maker.rb --source-dir=<path-to-source-dir> --dest-dir=<path-to-dest-dir>
    
    source-dir : The directory that contains the html pages and the include pages
    dest-dir: The directory to be created with the generated pages
</code>

### HOW IT WORKS

All the pages are parsed through for the [[inc: <include_file_name>]] tag and that tag is replaced with the contents of the include_file. Thats it !

include_file: the include file needs to be available at <source-dir>/_includes/<include_file_name>

Note: currently js, exe, gif, png, jpeg files are not parsed

### SOURCE FOLDER STRUCTURE

<code>
    |- _includes_
    |- <remaining files>
    \- <remaining files>
</code>

_includes_ : This folder must contain all the include_files that can be accessed via [[inc: <include_file_name>]]

### EXAMPLE

<code>
    source 
    |- _includes_
       |- header
       \- footer
    |- index.html
    \- logo.png
</code>

##### header: (include)
<code>
    <html>
    <head>
     <title>Simple Site Maker</title>
    <head>
    <body>
</code>

##### footer: (include)
<code>
    </body>
    </html>
</code>

##### index.html
<code>
    [[inc: header]]
    <img src="logo.png">
    Hello World
    [[inc: footer]]
</code>

##### Run the below command 
<code>
    ruby simple-site-maker.rb --source-dir=source --dest-dir=gen
    
    #"gen" folder is created with "index.html" in it
</code>

##### generated index.html
<code>
    <html>
    <head>
     <title>Simple Site Maker</title>
    <head>
    <body>
    <img src="logo.png">
    Hello World
    </body>
    </html>
</code>

Thats it !