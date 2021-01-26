#!/bin/bash

PORT="2021"
IP_CLIENT="127.0.0.1"
IP_SERVER="127.0.0.1"

echo "Iniciando cliente del protocolo ABFP"

echo "(2)Sending Headers"

echo "ABFP $IP_CLIENT" | nc -q 1 $IP_SERVER $PORT

echo "(3)Listening $PORT"

MSG=`nc -lp $PORT`

sleep 1

if [ "$MSG" == "OK_CONN" ]; then
	echo "Conexion establecida"
else
	echo "ERROR 1: La conexión no se ha producido con el servidor"
	exit 1
fi
