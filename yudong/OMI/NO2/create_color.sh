
for b in 0 1 2 3 4 5 6 7 8 9; do 
  let blue=b*25
  for g in 0 1 2 3 4 5 6 7 8 9; do 
    let green=g*25
    for r in 0 1 2 3 4 5 6 7 8 9; do   # red start from no zero 
      let red=r*25

 cnum=$r$g$b

if [ $cnum -gt 20 ]; then 

  echo \'set rgb $r$g$b $red $green $blue \'trans

fi

   done
 done
done
