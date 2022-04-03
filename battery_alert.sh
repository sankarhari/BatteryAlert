#!/bin/bash
beacon()
{
  SOUND_FILE="/opt/BatteryAlert/alien_beacon.wav"
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
#  echo $CHARGE_PERCENT
#  echo $BATTERY_STATE
  GET_PERCENT=$(echo $CHARGE_PERCENT | cut -c13-16)
  GET_PERCENT2=$(echo $GET_PERCENT | awk -F'%' '{print $1}')
  GET_STATE=$(echo $BATTERY_STATE | cut -d' ' -f 2)
  echo $GET_PERCENT
  echo $GET_PERCENT2
  echo $GET_STATE
  echo "--------"
  if [[ $GET_STATE = "discharging" && $GET_PERCENT2 -le 10 ]]
  then
    notify-send -u normal -i battery -t 5000 "$(echo -e "Your Laptop charge is less than 10%.\nPlease turn on power switch.")"
    beacon 1 $FLAG
  elif [[ ($GET_PERCENT2 -ge 99  && $GET_STATE = "fully-charged") ]]
  then
    notify-send -u normal -i battery -t 5000 "$(echo -e "Your Laptop charge is more than 99%.\nPlease turn off power switch.")"
    beacon 1 $FLAG
  fi
  #elif [[ ($GET_STATE = "fully-charged" && $GET_PERCENT -eq 10) || ($GET_PERCENT -ge 99  && $GET_STATE = "fully-charged") ]]
  sleep 10
done
