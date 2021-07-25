#!/bin/bash

DIR="../philo"


green="\033[32m"
red="\033[31m"
orange="\033[33m"
purple="\033[35m"
clear="\033[0m"
OK="[ ${green}OK${clear} ]"
KO="[ ${red}KO${clear} ]"



### HEADER
header()
{
echo -e "${orange}____________________________________________________________________________________________________________\n"
echo -e "________________________________________________ PHILO CHECKER _____________________________________________\n"
echo -e "____________________________________________________________________________________________________________\n\n${clear}"
}


compil()
{
header
echo -e "${orange}Testing compilation...${clear}"
cd $DIR && make -s re
[[ $? -ne 0 ]] && exit 1
}

ko=0
ok=0

meal()
{
for meal in 1 2 3 4 5 6 7 8 9 10; do
	nb_philo=$(echo $1 | cut -d" " -f1)
	echo -e "\n${purple}Testing ./philo $1 $meal${clear}\n"
	./philo $1 $meal > out
	x=1
	while [[ $x -le $nb_philo ]]; do
		check=$( cat out | grep "${x} is eating" | wc -l )
		[[ $check -ge $meal ]] && { echo -e "${OK} \c"; ok=$(( $ok + 1 )); } || { echo -e "${KO} \c"; ko=$(( $ko + 1 )); }
		echo -e "Philo $x ate ${check} / ${meal} times"
		x=$(( $x + 1 ))
	done
	rm -f out
done
}


death()
{
echo -e "\n${purple}Checking death with $1${clear}"
./philo $1 > out
check=$(cat out | grep "died" | wc -l)
[[ $check -eq 1 ]] && { echo -e ${OK}; ok=$(( $ok + 1 )); } || { echo -e ${KO}; ko=$(( $ko + 1 )); }
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
		exit 1
		;;
esac


### SUMMARY
total=$(( $ok + $ko ))
echo -e "\n\n${orange}--- SUMMARY ---${clear}"
echo -e "${green}Passed: ${ok} / ${total}${clear}"
echo -e "${red}Failed: ${ko} / ${total}${clear}"


### CLEANING AND EXIT
rm -f philo out

exit $ok
