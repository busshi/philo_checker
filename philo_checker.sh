#!/bin/bash

DIR="../philo"

compil()
{
cd $DIR && make
[[ $? -ne 0 ]] && exit 1
}

status_code=0

meal()
{
for meal in 1 2 3 4 5 6 7 8 9 10; do
	nb_philo=$(echo $1 | cut -d" " -f1)
	echo -e "\nTesting ./philo $1 $meal...\n"
	./philo $1 $meal > out
	x=1
	while [[ $x -le $nb_philo ]]; do
		check=$( cat out | grep "${x} is eating" | wc -l )
		[[ $check -ge $meal ]] && echo -e "[ \033[32;1mOK\033[0m ] \c" || { echo -e "[ \033[31;1mKO\033[0m ] \c"; status_code=$(( $status_code + 1 )); }
		echo -e "Philo $x ate ${check} / ${meal} times"
		x=$(( $x + 1 ))
	done
	rm -f out
done
}


death()
{
echo -e "\nChecking death with $1..."
./philo $1 > out
check=$(cat out | grep "died" | wc -l)
[[ $check -eq 1 ]] && echo -e "[ \033[32;1mOK\033[0m ]" || { echo -e "[ \033[31;1mKO\033[0m ]"; status_code=$(( $status_code + 1 )); }
rm -f out
}


### RUNNING TESTS
case $1 in
	"meal")
		compil
		$1 "5 800 200 200"
		$1 "4 410 200 200"
		$1 "2 300 100 100"
		;;
	"death")
		compil
		$1 "4 310 200 100 20"
		$1 "1 800 200 200"
		;;
	"all")
		compil
		meal "5 800 200 200"
		meal "4 410 200 200"
		meal "2 300 100 100"
		death "4 310 200 100 20"
		death "1 800 200 200"
		;;
	*)
		echo "Usage: ./philo_checker.sh [meal | death | all ]"
		;;
esac



### CLEANING AND EXIT
rm -f philo out

exit $status_code
