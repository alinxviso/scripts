#!/usr/bin/fish

set filetype flac
set newcodec aac
set bitrate 320K

if [ -z "$argv" ] || [ "$argv[1..-1]" = "-h" ]
	echo "usage: $(basename (status -f)) file/dir [-R]
	converts any applicable flac file to aac m4a and resizes
	all cover art to 320x320

	-R enables recursive searching for directories,
	required if the directory does not contain files
	directly
	
	will not overwrite files
	
	bitrate is set to $bitrate

	if converting directory, creates folder named \"converted\"
	if it it does not already exist in the current directory
	
	does not convert/rename or copy over m3u/m3u8 files, those
	will need to be edited manually or with another script"
	exit
end

if [ -e "$argv[1]" ]
else
	echo "file or directory $argv[1] does not exist!"
	exit
end


function __direrror
echo "converted exists but isn't a directory, please move or delete the blocking file"
exit
end

if [ -d "$argv[1]" ] # is a directory

	if [ -e converted ] # creates converted subdirectory if it doesn't exist already
		mkdir converted/(basename "$argv[1]") || __direrror
	else
		mkdir converted
		mkdir converted/(basename "$argv[1]")
	end

	if [ "$argv[2]" = "-R" ] # if searching recursively
		set collection "$argv[1]"
		for album in (command ls -d "$collection"/* | rev | cut -d/ -f-2 | rev) # for each folder in the collection, find each song and convert. outputs to converted/{album input}/{filename}.m4a
			mkdir converted/(basename "$collection")/(basename "$album") # make a directory for each album
			for file in (command ls "$album" | cut -d'	' -f2- | grep "$filetype") # for each song in the album
				ffmpeg -threads 0 -n -i "$album"/"$file" \
				-b:a "$bitrate" \
				-c:v mjpeg -vf scale=320x320 -disposition:v:0 attached_pic \
				-c:a "$newcodec" \
				converted/"$album"/(echo $file | string replace -r ".$filetype\$" ".m4a") # convert it and output to converted/$filename
				echo album = "$album"
				echo file = "$file"
				echo newcodec = "$newcodec"
			end		
		end
	
	else
		set album $argv[1]

		for file in (command ls "$album" | cut -d'	' -f2- | grep "$filetype") # for each song in the album
			ffmpeg -n -i "$album"/"$file" -b:a "$bitrate"K -c:v copy -c:a "$newcodec" -threads "$threads" converted/(basename "$album")/(echo $file | string replace -r ".$filetype\$" ".m4a") # convert it and output to converted/$filename
			echo album = "$album"
			echo file = "$file"
			echo newcodec = "$newcodec"
		end		
	end







else # if the input is a file
	set song $argv[1]
	ffmpeg -n -i "$song" -b:a "$bitrate"K -c:v copy -c:a "$newcodec" -threads "$threads" (echo (basename $argv[1]) | string replace -r".$filetype\$"'.m4a')
end
