#!/usr/bin/env fish

if [ -z "$argv" ] || [ "$argv[1..-1]" = "-h" ]
	echo "usage: $(basename (status -f)) file/dir filetype alac/aac [-R]
	converts any applicable audio file to alac m4a

	arguments MUST be in the order presented

	-R enables recursive searching for directories,
	required if the directory does not contain files
	directly
	
	filetype is what the file currently is, it must be the 
	whole extension, without leading period

	will not overwrite files
	
	copies bitrate for alac, sets cap at 320kbps for aac
	
	if converting directory, creates folder named \"converted\"
	if it it does not already exist in the current directory
	
	does not convert/rename or copy over m3u(8) files, those
	will need to be edited manually or with another script"
	exit
end

if [ "$argv[3]" != alac  ] && [ "$argv[3]" != "aac"  ]
	echo '$argv[3] is not alac or aac, please select one'\n
	echo "your arguments go like this,
	\$argv[1] = $argv[1]
	\$argv[2] = $argv[2]
	\$argv[3] = $argv[3]
	\$argv[4] = $argv[4]"

	exit
end

if [ -e "$argv[1]" ]
else
	echo "file or directory $argv[1] does not exist!"
	exit
end


# $argv[1] $argv[2] $argv[3] $argv[4]
# file/dir filetype alac/aac [-R]

set filetype $argv[2]
set newcodec $argv[3]

function getbitrate 
	ffprobe "$argv" 2>| grep bitrate | rev | cut -d ' ' -f 2 | rev
end
if [ "$argv[3]" = "aac" ] # if it's aac
	set bitrate 320
else
	set bitrate "$(getbitrate "$album"/"$file")"
end

if [ -d "$argv[1]" ] # is a directory

	if [ -e converted ] # creates converted subdirectory if it doesn't exist already
		mkdir converted/(basename "$argv[1]")
	else
		mkdir converted
		mkdir converted/(basename "$argv[1]")
	end

	if [ "$argv[4]" = "-R" ] # if searching recursively
		set collection "$argv[1]"
		for album in (command ls -d "$collection"/* | rev | cut -d'/' -f-2 | rev) # for each folder in the collection, find each song and convert. outputs to converted/{album input}/{filename}.m4a
			mkdir converted/"$album" # expands to converted/collection/album
			for file in (command ls "$album" | cut -d'	' -f2- | grep "$filetype") # for each song in the album
				ffmpeg -threads 0 -n -i "$album"/"$file" \ # use automatic number of threads, don't overwrite existing files, and choose input file
				-b:a "$bitrate"K \ # audio bitrate
				-c:v copy \ # keep video stream aka same cover art
				-c:a "$newcodec" converted/"$album"/(echo $file | string replace -r ".$filetype\$" ".m4a") # convert it and output to converted/$filename
				echo album = "$album"
				echo file = "$file"
				echo newcodec = "$newcodec"
			end		
		end
	
	else
		set album $argv[1]

		for file in (command ls "$album" | cut -d'	' -f2- | grep "$filetype") # for each song in the album
			ffmpeg -n -i "$album"/"$file" \
			-b:a "$bitrate"K \
			-c:v copy \
			-c:a "$newcodec" \
			-threads 0 \
			converted/(basename "$album")/(echo $file | string replace -r ".$filetype\$" ".m4a") # convert it and output to converted/$filename
			echo album = "$album"
			echo file = "$file"
			echo newcodec = "$newcodec"
		end		
	end

else # if the input is a file
	set song $argv[1]
	ffmpeg -n -i "$song" -b:a "$bitrate"K -c:v copy -c:a "$newcodec" -threads 0 (echo (basename $argv[1]) | string replace -r ".$filetype\$" ".m4a")
end
