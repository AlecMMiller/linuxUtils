cd

rm -rf dontTouch

printf "Copying contents of SD card to temporary directory\n"
mkdir -p dontTouch
cp /media/danielle/2973-789E/DCIM/*/*.JPG dontTouch -r

printf "Sorting by tags\n"
for f in dontTouch/*.JPG ; 
do TAG=`exif "$f" -t 0x9c9e -m` && DATE=`exif "$f" -t 0x0132 -m` && echo $f has tag $TAG && mkdir -p dontTouch/$TAG && mv $f dontTouch/$TAG/;
done

printf "Sorting by date\n"
for d in dontTouch/*/ ;
do echo sorting $d && TOP=`ls "$d" | head -n 1` && BOTTOM=`ls "$d" | tail -n 1` && TAG=`exif "$d/$BOTTOM" -t 0x9c9e -m` && TYEAR=`exif "$d/$TOP" -t 0x0132 -m | head -c4` && BYEAR=`exif "$d/$BOTTOM" -t 0x0132 -m | head -c4` && TMONTH=`exif "$d/$TOP" -t 0x0132 -m | head -c7 | tail -c2` && BMONTH=`exif "$d/$BOTTOM" -t 0x0132 -m | head -c7 | tail -c2` && if [ "$TYEAR" = "$BYEAR" ]
	then
	if [ "$TMONTH" = "$BMONTH" ]
		then
		mkdir -p dontTouch/"$TYEAR"/"$TYEAR $TMONTH $TAG"/ && mv "$d"/* dontTouch/"$TYEAR"/"$TYEAR $TMONTH $TAG" && rm -rf "$d"
	else
		mkdir -p dontTouch/"$TYEAR"/"$TYEAR $TMONTH-$BMONTH $TAG"/ && mv "$d"/* dontTouch/"$TYEAR"/"$TYEAR $TMONTH-$BMONTH $TAG" && rm -rf "$d"
		fi
else
	printf "Error, files exist across two years, please manually sort\n"
fi;
done

printf "Cleaning up untagged\n"
for f in dontTouch/*.JPG ; 
  do echo $f is untagged && mkdir -p dontTouch/Untagged && mv $f dontTouch/Untagged/;
done

printf "Returning to console\n"
exec bash
