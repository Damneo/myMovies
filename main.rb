#MAIN PROGRAM
require File.dirname(__FILE__) + '/myMovies'

conf = {
	#'path' 	=> 'the/path/to/your/movies/folder',
	'exts' 	=> ['avi','mpeg','mpg','mkv','iso','mov'],
	#'duration' => true
}

myMovies = MyMovies.new(conf)
myMovies.exportToTxt