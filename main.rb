#MAIN PROGRAM
require File.dirname(__FILE__) + '/myMovies'

conf = {
	#'path' 	=> '/media/neo/My Passport/Films',
	#'path' 	=> '/home/neo/Dev'
	#'path' 	=>'/media/neo/MAXTOR/Films',
	#'exts' 	=> ['avi','mpeg','mpg','mkv','iso','mov'],
	'duration' => true
}

myMovies = MyMovies.new(conf)
myMovies.exportToJson