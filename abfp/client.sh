#!/bin/bash

PORT="2021"
IP_CLIENT="127.0.0.1"
IP_SERVER="127.0.0.1"

clear

echo "Iniciando cliente del protocolo ABFP"

echo "(2)Sending Headers"

echo "ABFP $IP_CLIENT" | nc -q 1 $IP_SERVER $PORT

echo "(3)Listening $PORT"

RESPONSE=`nc -lp $PORT`

sleep 1

echo "Test Message"

if [ "$RESPONSE" != "OK_CONN" ]; then
	echo "ERROR 1: La conexión no se ha producido con el servidor"
	exit 1
fi

echo "(6)Enviando Handshake"

echo "THIS_IS_MY_CLASSROOM" | nc -q 1 $IP_SERVER $PORT

echo "(7)Listening $PORT"

RESPONSE=`nc -lp $PORT`

sleep 1

echo "Test Handshake"

if [ "$RESPONSE" != "YES_IT_IS" ]; then
	echo "ERROR 2: Handshake no se ha recibido correctamente"
	exit 2
fi

exit 0
