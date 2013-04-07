#encoding: utf-8

class MyMovies

	def initialize(conf)

		@dir 		= (conf['path'] == nil) ? Dir.pwd : conf['path']
		@extensions = (conf['exts'] == nil) ? '*' 	 : conf['exts']
		@duration 	= (conf['duration']) 	? conf['duration'] : false

		@videos 	= []

		@maxTitle	= ''

		collectMovies(@dir)
	end

	def collectMovies(dir)
		@tmp_videos = []

		Dir[dir + '/**/*.*'].each { |f|

			if (@extensions == '*' || @extensions.include?(File.extname(f).delete('.').downcase))

				temp = {
					'title'    => File.basename(f,(File.extname(f))),
					'ext'      => File.extname(f).delete('.').upcase,
					'duration' => (@duration) ? get_movie_duration(f) : 'NK',
					'size'     => fileSize(File.size(f))
				}

				@maxTitle = (temp['title'].length > @maxTitle.length) ? temp['title'] : @maxTitle

				@tmp_videos.push(temp)
			end
		}

		@videos = @tmp_videos.sort_by { |k| k['title'] }
	end

	def fileSize(size)
		giga = 1073741824.0
		mega = 1048576.0
		kilo = 1024.0

		case
			when size < kilo
				sizeStr = size.to_s + ' Bytes' 
			when size < mega
				sizeStr = (size/kilo).to_f.round(1).to_s + ' KiB'	
			when size < giga
				sizeStr = (size/mega).to_f.round(1).to_s + ' MiB'	
			else
				sizeStr = (size/giga).to_f.round(1).to_s + ' GiB'
		end

		return sizeStr
	end

	def get_movie_duration(video_file)
	
	  # Run ffmpeg on the video, and do it silently
	  ffmpeg_output = `/usr/bin/ffmpeg -i "#{video_file}" 2>&1`
		
	  # Find the duration in the output, and force a return if it's found
	  /duration: ([0-9]{2}:[0-9]{2}:[0-9]{2})/i.match(ffmpeg_output) { |m| return m[1] }
	 
	  # If it didn't get a match, something is wrong. Log the error
	  return "NK"
	 
	end

	def exportToXml
		require 'builder'

		xml = Builder::XmlMarkup.new(:indent => 2 )
		xml_data = xml.target!
		xml.instruct! :xml, :version => "1.1", :encoding => "UTF-8"

		xml.movies :total => @videos.length do 
		 @videos.each do |v|
		  xml.movie{|b| 
		  	b.title(v['title']);
		  	b.extension(v['ext']);
		  	b.duration(v['duration']);
		  	b.size(v['size'])
		  }
		 end
		end

		file = File.new("my_movies.xml", "w")
		file.write(xml_data)
		file.close

		puts 'XML file generated !'
	end

	def exportToJson
		require 'json'

		json_data 	= @videos.to_json
		file 		= File.new("my_movies.json", "w")
		file.write(json_data)
		file.close
	end

	def exportToSql
		sql = "CREATE TABLE IF NOT EXISTS `movies` (
		  `id` int(11) NOT NULL AUTO_INCREMENT,
		  `title` varchar(250) NOT NULL,
		  `extension` varchar(5) NOT NULL,
		  `size` varchar(10) NOT NULL,
		  `duration` varchar(10) NOT NULL,
		  PRIMARY KEY (`id`)
		) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;\n\n"
		
		@videos.each do |v|
		  sql += "INSERT INTO `movies` (`id`, `title`, `extension`, `size`, `duration`) VALUES ('', '#{v['title'].gsub("'","\\\\'")}', '#{v['ext']}', '#{v['size']}', '#{v['duration']}');\n"
		end

		file = File.new("my_movies.sql", "w")
		file.write(sql)
		file.close

		puts 'SQL file generated !'
	end

	def exportToXls
		require 'axlsx'
		p = Axlsx::Package.new
		 
		# Required for use with numbers
		p.use_shared_strings = true
		 
		p.workbook do |wb|
		  # define your regular styles
		  styles 	= wb.styles
		  title 	= styles.add_style :sz => 18, :alignment => { :horizontal => :center, :vertical => :center }, :b => true
		  subtitles = styles.add_style :sz => 15, :alignment => { :horizontal => :center, :vertical => :center }, :border => { :style => :medium, :color => '00000000'}
		  normalRow = styles.add_style :sz => 10, :alignment => { :horizontal => :center }, :border => { :style => :thin, :color => '00000000'}
		 
		  wb.add_worksheet(:name => 'My Movies') do  |ws|
		  	ws.add_row ['My movies collection - ' + @videos.length.to_s + ' Movies'], :style => title, :height => 30
		  	ws.add_row
		    ws.add_row ['Num', 'Title', 'Duration', 'Size', 'Extension'], :style => subtitles, :widths => [6, :auto, :auto, :auto, :auto]
		    ws.add_row

		    i = 0

		    @videos.each do |v|
		    	i += 1
		  		ws.add_row [i, v['title'], v['duration'], v['size'], v['ext']], style: [normalRow, normalRow, normalRow, normalRow, normalRow]
			end
		 
		    ws.merge_cells 'A1:E1'
		 
		  end
		end
		p.serialize 'my_movies.xlsx'

		puts 'Xls file generated !'
	end

	def exportToTxt

		txtFile 	= File.new("myMovies.txt", "w")
		tabTitles 	= ["title","ext","duration","size"]

		txtFile.write("Liste des " + @videos.length.to_s + " films\n\n")

		#Tab header
		@str =  '+' + '-'*(@maxTitle.length+2) + '+'
		@str += '-'*6 + '+'
		@str += '-'*7 + '+'
		@str += '-'*8 + '+\n'
		puts @str

		@videos.each {|v|
			txtFile.write(v['title'] + "\n")
		}
	end
end