#!/bin/bash

IP="127.0.0.1"
PORT="2021"

echo "(0)Iniciando servidor del protocolo ABFP"

echo "(1)Escuchando puerto $PORT"

MSG=`nc -lp $PORT`

sleep 1

CHECK=`echo $MSG | cut -d " " -f 1`

echo "(4)Comprobar mensage"

if [ "$CHECK" == "ABFP" ]; then
	echo "Todo correcto"
	echo "OK_CONN" | nc -q 1 $IP $PORT
else
	echo "ERROR 1"
	echo "ERROR 1" | nc -q 1 $IP $PORT
	exit 1
fi

