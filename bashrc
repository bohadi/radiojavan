javanlyric(){
  local name=$(echo ${1} ${2} | tr -d - | tr -s ' ' | sed 's/ /-/g')
  local lyrics=$(curl -s https://www.radiojavan.com/mp3s/mp3/$name |
    grep -A 1 lyricsFarsi | tail -n +2  | tr -d '\t')
  echo $lyrics | sed 's/<br\/>/\n/g' | xclip
  echo $lyrics | sed 's/<br\/>/\n/g'
}

javanalbum(){
  local img=$(curl -s https://www.radiojavan.com/radio/player | grep song_photo | grep -oP 'src="\K[^"]+')
  curl $img --output ~/media/music/radiojavan_tmp.jpg
}

radiojavan(){
  mpv --quiet --force-window=no http://rj2.rjstream.com/ |
    while read -r line; do
      if [[ $line =~ (icy-title) ]] && ! [[ $line =~ (Radio Javan) ]]; then
        local asdasd=$(echo $line | cut -c 11-)
        javanalbum &>/dev/null
        chafa -s 25 ~/media/music/radiojavan_tmp.jpg
        echo '  ♫ 你在听着‥' $asdasd '❤️♡'
        local name=$(echo $line | grep -oP "(?<=icy-title: )[^-]*")
        local song=$(echo $line | grep -oP "(?<=- ).*")
        notify-send -i ~/media/music/radiojavan_tmp.jpg -t 10000 "${name}" "${song}"
        javanlyric "${name}" "${song}"
        echo '  ─────────'
      fi
    done
}

