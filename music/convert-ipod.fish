#!/usr/bin/env fish

set newcodec aac
set bitrate 320K
set max_jobs (nproc --all || echo 4)

if test (count $argv) -eq 0; or test "$argv[1..-1]" = "-h" 
	echo "usage: $(path basename (status -f)) file/dir [-R]
	converts any applicable flac file to aac m4a and reencodes
	pre-existing m4a files

	-R enables recursive searching for directories,
	required if the directory does not contain files
	directly
	
	will not overwrite files
	
	bitrate is set to $bitrate

	does not convert/rename or copy over m3u/m3u8 files, those
	will need to be edited manually or with another script"
	exit 0
end

if not test -e "$argv[1]" 
else
	echo "file or directory $argv[1] does not exist!"
	exit
end


if test -d "$argv[1]"  # is a directory

	if test "$argv[2]" = "-R"  # if searching recursively
		set collection "$argv[1]"
		for album in (command ls -d "$collection"/*)  # for each folder in the collection, find each song and convert. outputs to Music/{album input}/{filename}.m4a
			mkdir -p (basename "$album") # make a directory for each album
			#echo album = "$album"
			#echo newcodec = "$newcodec"
			echo "Converting $album to $newcodec"
			for file in "$album"/*.{m4a,dlac}  # for each song in the album
				set output_file (path basename "$album")/(path change-extension m4a -- (path basename "$file"))
				ffmpeg -hide_banner -loglevel error -threads 0 -n -i "$file" \
				-b:a "$bitrate" \
				-c:v copy \
				-c:a "$newcodec" \
				"$output_file" & #& printf "Done!\n\n" # convert it and output to Music/Album/$filename
				while test (jobs -p | count) -ge $max_jobs
					sleep 0.1
				end
			end	
			wait
			printf "Done!\n\n"
		end
	
	else
		set album $argv[1]
			mkdir -p (basename "$album") # make a directory for each album

		for file in "$album"/*.{m4a,flac} # for each song in the album
			echo album = "$album"
			echo file = "$file"
			echo newcodec = "$newcodec"
			set output_file (path basename "$album")/(path change-extension m4a -- (path basename "$file"))
			echo output = "$output_file"

			ffmpeg -n -hide_banner -loglevel error -i "$file" \
			-b:a "$bitrate" \
			-c:a "$newcodec" \
			-c:v copy \
			-threads 0 \
			"$output_file" && printf "Done!\n\n" # convert it and output to Music/$filename
		end		
	end







else # if the input is a file
	set song $argv[1]
	ffmpeg -n -i "$song" -b:a "$bitrate" -c:v copy "$newcodec" -threads 0 (echo (basename $argv[1]) | string replace -r ".$filetype\$"'.m4a')
end
