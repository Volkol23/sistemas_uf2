#!/bin/bash

IP="127.0.0.1"
PORT="2021"

clear

echo "(0)Iniciando servidor del protocolo ABFP"

echo "(1)Escuchando puerto $PORT"

HEADER=`nc -lp $PORT`

sleep 1

PREFIX=`echo $HEADER | cut -d " " -f 1`
IP_CLIENT=`echo $HEADER | cut -d " " -f 2`

echo "Comprobar header"

if [ "$PREFIX" != "ABFP" ]; then
	echo "ERROR 1: No se ha recibido correctamente la IP"
	echo "KO_CONN" | nc -q 1 $IP $PORT
	exit 1
fi

echo "(4)Responder Header"

echo "Todo correcto"
echo "OK_CONN" | nc -q 1 $IP $PORT


echo "(5)Escuchando puerto $PORT"

HANDSHAKE=`nc -lp $PORT`

sleep 1

echo "Comprobar"

if [ "$HANDSHAKE" != "THIS_IS_MY_CLASSROOM" ]; then
	echo "ERROR 2: No se ha recibido el Handshake correctamente"
	echo "KO_HANDSHAKE" | nc -q 1 $IP $PORT
	exit 2
fi

echo "(8)Responder Handshake"

echo "Todo correcto"
echo "YES_IT_IS" | nc -q 1 $IP $PORT


echo "(9)Escuchando puerto $PORT"

MSG=`nc -lp $PORT`

sleep 1

FILE_PREFIX=`echo $MSG | cut -d " " -f 1`
FILE_NAME=`echo $MSG | cut -d " " -f 2`

echo "Comprobar File Name"

if [ "$FILE_PREFIX" != "FILE_NAME" ]; then
	echo "ERROR 3: No se ha recibido el File Name correctamente"
	echo "KO_FILE_NAME" | nc -q 1 $IP $PORT
	exit 2
fi

echo "(12)Responder File Name ($FILE_NAME)"

echo "Todo correcto"
echo "OK_FILE_NAME" | nc -q 1 $IP $PORT


echo "(13)Listening $PORT"

nc -lp $PORT > archivo_entrada.vaca

MYMD5=`md5 archivo_entrada_vaca`

MD5=`nc -lp $PORT`
SENDMS5=`echo $MD5 | cut -d " " -f 1`

if [$MYMD5 != $SENDMD5 ]; then
	echo "KO_DATA" | nc -q 1 $IP $PORT
else
	echo "Todo correcto"
	echo "OK_DATA" | nc -q 1 $IP $PORT
fi

sleep 1

exit 0
