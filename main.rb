#MAIN PROGRAM
conf = {
	#'path' 	=> '/media/neo/My Passport/Films',
	#'path' 	=> '/home/neo/Dev'
	#'path' 	=>'/media/neo/MAXTOR/Films',
	#'exts' 	=> ['avi','mpeg','mpg','mkv','iso','mov'],
	'duration' => true
}

mesVideos = MyMovies.new(conf)
mesVideos.exportToXls