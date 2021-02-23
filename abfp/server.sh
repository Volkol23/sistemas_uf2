#!/bin/bash

IP="127.0.0.1"
PORT="2021"
OUTPUT_PATH="salida_server/"
clear

echo "(0)Iniciando servidor del protocolo ABFP"

echo "(1)Escuchando puerto $PORT"

HEADER=`nc -lp $PORT`

sleep 1

PREFIX=`echo $HEADER | cut -d " " -f 1`
IP_CLIENT=`echo $HEADER | cut -d " " -f 2`

echo "Comprobar Header"

if [ "$PREFIX" != "ABFP" ]; then
	echo "ERROR 1: No se ha recibido correctamente la IP"
	sleep 1
	echo "KO_CONN" | nc -q 1 $IP $PORT
	exit 1
fi

echo "(4)Responder Header"

echo "Todo correcto"
sleep 1
echo "OK_CONN" | nc -q 1 $IP $PORT


echo "(5)Escuchando puerto $PORT"

HANDSHAKE=`nc -lp $PORT`

sleep 1

echo "Comprobar Handshake"

if [ "$HANDSHAKE" != "THIS_IS_MY_CLASSROOM" ]; then
	echo "ERROR 2: No se ha recibido el Handshake correctamente"
	sleep 1
	echo "KO_HANDSHAKE" | nc -q 1 $IP $PORT
	exit 2
fi

echo "(8)Responder Handshake"

echo "Todo correcto"
sleep 1
echo "YES_IT_IS" | nc -q 1 $IP $PORT


echo "(9)Escuchando puerto $PORT"

MSG=`nc -lp $PORT`

sleep 1

FILE_PREFIX=`echo $MSG | cut -d " " -f 1`
FILE_NAME=`echo $MSG | cut -d " " -f 2`
FILE_MD5=`echo $MSG | cut -d " " -f 3`

echo "Comprobar File Name"

if [ "$FILE_PREFIX" != "FILE_NAME" ]; then
	echo "ERROR 3: No se ha recibido el File Name correctamente"
	sleep 1
	echo "KO_FILE_NAME" | nc -q 1 $IP $PORT
	exit 3
fi

echo "(12)Responder File Name ($FILE_NAME)"

echo "Todo correcto"
sleep 1
echo "OK_FILE_NAME" | nc -q 1 $IP $PORT


echo "(13)Escuchando puerto $PORT"

sleep 1

nc -lp $PORT > $OUTPUT_PATH$FILE_NAME

sleep 1

SEND_MD5=`nc -lp $PORT`

MY_MD5=`md5sum $OUTPUT_PATH$FILE_NAME | cut -d " " -f 1`

echo "Test MD5"

if [ "$MY_MD5" != "$SEND_MD5" ]; then
	echo "KO_DATA" | nc -q 1 $IP $PORT
else
	echo "Todo correcto"
	sleep 1
	echo "OK_DATA" | nc -q 1 $IP $PORT
fi

sleep 1

exit 0
