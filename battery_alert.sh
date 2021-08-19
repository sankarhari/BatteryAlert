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
  FLAG=`dpkg --get-selections sox | awk '{print match($0,"install")}'`
  CHARGE_PERCENT=`upower -i $(upower -e | grep BAT) | grep --color=never -E "percentage"`
  BATTERY_STATE=`upower -i $(upower -e | grep BAT) | grep --color=never -E "state"`
  GET_PERCENT=$(echo $CHARGE_PERCENT | cut -c13-14)
  GET_STATE=$(echo $BATTERY_STATE | cut -d' ' -f 2)
  if [ $GET_STATE = "discharging" -a $GET_PERCENT -le 30 ]
  then
    notify-send -u normal -i battery -t 5000 "$(echo -e "Your Laptop charge is less than 30%.\nPlease turn on power switch.")"
    beacon 1 $FLAG
  elif [ $GET_STATE = "charging" -a $GET_PERCENT -ge 90 ]
  then
    notify-send -u normal -i battery -t 5000 "$(echo -e "Your Laptop charge is more than 90%.\nPlease turn off power switch.")"
    beacon 1 $FLAG
  fi
  sleep 10
done
