# if ps files are given in command line, convert them. Otherwise, convert all
# ps files found in cwd.

TMPDIR=/tmp

if [ $# -eq 0 ]; then
  files=*.ps
else
  files=$@
fi


for file in $files; do
  stem=${file%.*}
  ps2pdf ${stem}.ps ${stem}.pdf
  gs -dBATCH -q -dNOPAUSE -sDEVICE=png16m -sOutputFile=${stem}.png -r400x400 ${file}
  gs -dBATCH -q -dNOPAUSE -sDEVICE=png16m -sOutputFile=${stem}-sm.png  ${file}
  convert -trim ${stem}.png $TMPDIR/tmp.png
  convert -rotate 90 $TMPDIR/tmp.png ${stem}-trim.png
  convert -trim ${stem}-sm.png $TMPDIR/tmp-sm.png
  convert -rotate 90 $TMPDIR/tmp-sm.png ${stem}-trim-sm.png
done

