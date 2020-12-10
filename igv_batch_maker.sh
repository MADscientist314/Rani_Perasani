rm test.sh
for n in $(cat positions.txt);
do
    echo "goto" $n>>test.sh;
    echo "expand">>test.sh;
    echo 'snapshot place.png'>>test.sh;
done
