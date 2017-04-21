#!/usr/bin/env bash

#Set script name
SCRIPT=`basename ${BASH_SOURCE[0]}`

#Set default values
protocol=IPv4
returnCode=0

# help function
function printHelp {
  echo -e "Nagios check for BGP protocols BIRD routing daemon v1.0"
  echo -e "Help for $SCRIPT"
  echo -e "Basic usage: $SCRIPT -p {protocol}"
  echo -e "-p Sets process check for given protocol: IPv4 or IPv6"
  echo -e "-h Displays this help message"
  echo -e "Example: $SCRIPT -p IPv4"
  echo -e "Author: Rafal Dwojak, rafal@dwojak.com"
  echo -e "Github: https://github.com/rafaldwojak/check_BIRD_BGP_protocols"
  exit 1
}

re='^IPv([4|6]+)$'
while getopts :p:h FLAG; do
  case $FLAG in
    p)
      if ! [[ $OPTARG =~ $re ]] ; then
        echo "error: Invalid parameter" >&2; exit 1
      else
        protocol=$OPTARG
      fi
      ;;
    h)
      printHelp
      ;;
    \?)
      echo -e "Option -$OPTARG not allowed.\\n"
      printHelp
      exit 2
      ;;
  esac
done

shift $((OPTIND-1))

if [ "$protocol" == "IPv4" ]; then
protoArray=($(birdc show protocols | grep BGP | awk '{ print $1 }' | tr '\n' ' ' ))
else
protoArray=($(birdc6 show protocols | grep BGP | awk '{ print $1 }' | tr '\n' ' ' ))
fi


#printf "%s\n" "${protoArray[@]}"
outputString="Configured Protocols ->"${protoArray[@]}"\\\n"

for i in "${protoArray[@]}"
do

if [ "$protocol" == "IPv4" ]; then
readarray -t protoStatus <<< "$(birdc show protocols $i)"
else
readarray -t protoStatus <<< "$(birdc6 show protocols $i)"
fi

read -ra ps <<< "${protoStatus[2]}"
#printf "%s\n" "${ps[@]}"

if [ "${ps[5]}" == "Established" ]; then
    outputString=$outputString"OK: ${ps[0]} ${ps[5]}\\\n"
else
    outputString=$outputString"CRITICAL: ${ps[@]}\\\n"
    returnCode=2
fi

done
echo -e "$outputString"
exit $returnCode
