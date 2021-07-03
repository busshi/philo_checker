#!/bin/bash




error=0

check()
{
[ $? -ne 0 ] && error=$(( $error + 1 ))
}

../philo/philo 4 410 200 200
check
../philo/philo 5 800 200 200
check
../philo/philo 5 800 200 200 7
check
../philo/philo 1 800 200 200 
check
../philo/philo 2 100 100 100
check
../philo/philo 4 310 200 100 #mort
check


exit $error
