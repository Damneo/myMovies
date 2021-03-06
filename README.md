myMovies
========

## 1.- What is this ?
> My Movies is a **Ruby class** that allows you to generate a list of your movies files and export it in different formats 
like xml, sql, json, excel and text

## 2.- How it works ?
*main.rb*
```ruby
#MAIN PROGRAM
require File.dirname(__FILE__) + '/myMovies'

conf = {
	#'path' 	=> 'the/path/to/your/movies/folder',
	'exts' 	=> ['avi','mpeg','mpg','mkv','iso','mov'],
	#'duration' => true
}

myMovies = MyMovies.new(conf)
myMovies.exportToXls
```

### 2-1.- Configuration options
| Name      | Description           | Type | Required  | Default |
| --------- | ------------- | ----- | ----- | ----- |
|path      |Absolute path to the folder where video files are going to be listed |String |false  | Current folder  |
|exts      |Extensions files that you want to list |Array |false |All extension files |
|duration  |Set if you want to get the duration of movies |Boolean |false |false |

### 2-2.- Does that use external ressources ?
Yes, here are what we (optionnaly) need :
* **FFmpeg** : This [software](http://www.ffmpeg.org/) is a video codec. It is used to get the duration of your movie file.
Installation procedure (for Ubuntu) [here](http://doc.ubuntu-fr.org/ffmpeg)
* **Axlsx gem** : This gem enables the Excel export option. You can install this gem and find documentation on the project [page](https://github.com/randym/axlsx)

```
$ gem install axlsx
```
* **text-table gem** : This great gem format the text file data in a table view for the Text export option. You can install this gem and find documentation on the project [page](https://github.com/aptinio/text-table)

```
$ gem install text-table
```

### 2-3.- Returned data

The class returns **4** data for each movie file :

| Name      | Example  | Info |
| --------- | -------- | ---- |
|Title      |"Match Point"|-|
|Size       |"699.9 MiB" |-|
|Duration   |"01:50:12" |If **duration** is not activated in options configuration, the returned value is "NK"|
|Extension  |"avi" |-|

## 3.- What are the export formats ?

You can export your movies list in several different formats : 
* Xml format
* Sql format
* Excel format
* Json format
* Text format

*main.rb*
```ruby
#MAIN PROGRAM
require File.dirname(__FILE__) + '/myMovies'

....

myMovies = MyMovies.new()

myMovies.exportToXml
myMovies.exportToSql
myMovies.exportToXls
myMovies.exportToJson
myMovies.exportToTxt
```

## 4.- Last things you should know
##### 1.- FFmpeg & Duration movie
> Using FFmpeg to get video duration may take some time. In order to get the duration, FFmpeg needs to open the file. If 
you have lot of movies to list, it can be quite longer than if you wouldn't use this feature.
