#! /bin/bash
shopt -s globstar || exit
for PIC in **
do
# look only for jpg
if [[ "$PIC" =~ \.JPG$ ]] || [[ "$PIC" =~ \.jpg$ ]]; then
        echo "file_$PIC"
        # get the date and time from the tag DateTimeOriginal
        DATE=$(exiftool -p '$DateTimeOriginal' "$PIC" | sed 's/[: ]//g')
        LONGDATE=$(echo $DATE | sed -e 's/^\(.\{12\}\).*/\1/')
            # check if DateTimeOriginal is 0000... OR empty
            if [[ "$LONGDATE" != "000000000000" ]] && [[ -n "$LONGDATE" ]]; then
            echo "datetimeoriginal_$LONGDATE"
            # modify the attribute date with the info in the tag date
            touch -t $LONGDATE "$PIC"
            # customize date, in this case eliminate the time, getting only the date in 8 numbers and adding _
            DATEMOD2=$(echo $DATE | sed -e 's/^\(.\{8\}\).*/\1_/')
            echo "datemod2_$DATEMOD2"
                    # skip renaming if
                    # 8 numbers at beginning followed by _ or after IMG_ or P_ and followed by _ (already date stamped)
                    if [[ "$PIC" =~ [[:digit:]]{8}_.*$ ]] || [[ "$PIC" =~ IMG_[[:digit:]]{8}_.*$] ]] || [[ "$PIC" =~ P_[[:digit:]]{8}_.*$] ]]; then
                    :
                    else
                    # this will be done

                    filename=$(basename "$PIC")
                    echo "$filename"
                    echo "mv -i \""$PIC"\" \""$(dirname "$PIC")"/"$DATEMOD2""$filename"\""
                    #uncomment if you like it
                    mv -i "$PIC" "$(dirname "$PIC")/$DATEMOD2$filename"

                    fi
            else
            # get the date and time from the tag HistoryWhen

            DATE=$(exiftool -p '$HistoryWhen' "$PIC" | sed 's/[: ]//g')
            LONGDATE=$(echo $DATE | sed -e 's/^\(.\{12\}\).*/\1/')

            # check if Historywhen is 0000... or empty
                if [[ "$LONGDATE" != "000000000000" ]] && [[ -n "$LONGDATE" ]]; then
                echo "historywhentag_$LONGDATE"

                touch -t $LONGDATE "$PIC"
                DATEMOD2B=$(echo $DATE | sed -e 's/^\(.\{8\}\).*/\1_/')
                echo "datemod2B_$DATEMOD2B"

                    if [[ "$PIC" =~ [[:digit:]]{8}_.*$ ]] || [[ "$PIC" =~ IMG_[[:digit:]]{8}_.*$] ]] || [[ "$PIC" =~ P_[[:digit:]]{8}_.*$] ]]; then
                    :
                    else
                    # this will be done             
                    filename=$(basename "$PIC")
                    echo "$filename"
                    echo "mv -i \""$PIC"\" \""$(dirname "$PIC")"/"$DATEMOD2B""$filename"\""
                    #uncomment if you like it
                    mv -i "$PIC" "$(dirname "$PIC")/$DATEMOD2B$filename"
                    fi

                else
                    # get the date and time from the tag tag filemodifydate

                    DATE=$(exiftool -p '$filemodifydate' "$PIC" | sed 's/[: ]//g')
                    LONGDATE=$(echo $DATE | sed -e 's/^\(.\{12\}\).*/\1/')

                    # check if filemodifydate is 0000... or  empty
                    if [[ "$LONGDATE" != "000000000000" ]] && [[ -n "$LONGDATE" ]]; then
                    #echo "filemodifydatetag_$LONGDATE"

                    #touch -t $LONGDATE "$PIC"
                    DATEMOD2C=$(echo $DATE | sed -e 's/^\(.\{8\}\).*/\1_/')
                    echo "datemod2C_$DATEMOD2C"

                        if [[ "$PIC" =~ [[:digit:]]{8}_.*$ ]] || [[ "$PIC" =~ IMG_[[:digit:]]{8}_.*$] ]] || [[ "$PIC" =~ P_[[:digit:]]{8}_.*$] ]]; then
                        :
                        else
                        # this will be done             
                        filename=$(basename "$PIC")
                        echo "$filename"
                        echo "mv -i \""$PIC"\" \""$(dirname "$PIC")"/"$DATEMOD2C""$filename"\""
                        #uncomment if you like it
                        mv -i "$PIC" "$(dirname "$PIC")/$DATEMOD2C$filename"
                        fi

                    else

                    echo "Error, NO date available"
                    fi
                fi
            fi
fi
done
