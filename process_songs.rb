# To run, pass the filename as the argument. For example: `ruby process_songs.rb Albums.txt`

def process_albums(filename)
	median_song_length  = get_median_song_length_in_seconds(filename)

	current_album = {}
	albums_less_than_median_length = []

	File.readlines(filename).each do |line|
		possible_album = /(.+)\/(.+)\/(.+)/.match(line)
		if (possible_album)
			current_album[:artist] = possible_album[1]
			current_album[:album] = possible_album[2]
			current_album[:year] = possible_album[3]
			next
		end

		possible_song = /(.+)\s+-\s+(.+)/.match(line)
		if (possible_song)
			song_name = possible_song[1]
			song_length = possible_song[2]
			song_display_line = "#{current_album[:artist]} - #{current_album[:album]} - #{current_album[:year]} - #{song_name} - #{song_length}"

			song_length_separated = /(\d+):(\d+)/.match(song_length)
			song_length_in_seconds = song_length_separated[1].to_i * 60 + song_length_separated[2].to_i

			if song_length_in_seconds <= median_song_length
				albums_less_than_median_length << [song_display_line, song_length_in_seconds]
			end
		end
	end

	total_playlist_length = 0

	albums_less_than_median_length = albums_less_than_median_length.sort_by { |album_arr| album_arr[1] }

	albums_less_than_median_length.each_with_index do |album_arr, album_idx|
		total_playlist_length += album_arr[1]
		puts "#{album_idx + 1}. " + album_arr[0]
	end

	puts "Total Time: #{total_playlist_length / 60}:#{total_playlist_length % 60}"
end

def get_median_song_length_in_seconds(filename)
	songs_length_seconds = []

	File.readlines(filename).each do |line|
		current_song_raw_length = /(\d+):(\d+)/.match(line)
		next if current_song_raw_length.nil?

		current_song_length_seconds = current_song_raw_length[1].to_i * 60 + current_song_raw_length[2].to_i
		songs_length_seconds << current_song_length_seconds
	end

	songs_length_seconds.sort!

	mid = songs_length_seconds.length / 2
	songs_length_seconds.length.odd? ? songs_length_seconds[mid] : 0.5 * (songs_length_seconds[mid] + songs_length_seconds[mid - 1])
end


if ARGV.length > 1
	puts "Program only takes one argument."
elsif ARGV.length == 0
	puts "Please provide a filename to process."
elsif ARGV.length == 1
	process_albums(ARGV[0])
end