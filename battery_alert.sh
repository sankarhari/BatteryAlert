#!/bin/bash
beacon()
{
  SOUND_FILE="/opt/BatterAlert/alien_beacon.wav"
  if [ "$1" -eq "1" -a $2 -gt 0 -a -f $SOUND_FILE ]
  then
    for i in {1..3}
    do
      play $SOUND_FILE
    done
  elif [ "$1" -eq "1" -a $2 -gt 0 ]
  then
    for i in {1..3}
    do
      echo -e "\a"
      sleep 0.7
    done
  elif [ "$1" -eq "1" -a $2 -eq 0 ]
  then
    for i in {1..3}
    do
      echo -e "\a"
      sleep 0.7
    done
  fi
}

#Test Beacon
# beacon 1 0
while true
do
  FLAG=`dpkg --get-selections sox | awk '{print match($0,"install")}' `
  FLAG_DISCHARGING=`upower -i $(upower -e | grep BAT) | grep --color=never -E "state" | awk '{print match($0,"discharging")}'`
  FLAG_CHARGING=`upower -i $(upower -e | grep BAT) | grep --color=never -E "state" | awk '{print match($0,"charging")}'`
  CHARGE_PERCENT=`upower -i $(upower -e | grep BAT) | grep --color=never -E "percentage"`
  GET_PERCENT=$(echo $CHARGE_PERCENT | cut -c13-14)
  if [ $FLAG_DISCHARGING -gt 0 -a $FLAG_CHARGING -eq 0 -a $GET_PERCENT -le 35 ]
  then
    echo "Your Laptop is changed less than or  36%. Please turn on power switch"
    beacon 1 $FLAG
  elif [ $FLAG_DISCHARGING -eq 0 -a $FLAG_CHARGING -gt 0 -a $GET_PERCENT -ge 82 ]
  then
    echo "Your Laptop is changed more than %. Please turn off power switch"
    beacon 1 $FLAG
  fi
  sleep 300
done
