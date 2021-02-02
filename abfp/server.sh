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

echo "(4)Comprobar mensaje"

if [ "$PREFIX" != "ABFP" ]; then
	echo "ERROR 1: No se ha recibido correctamente la IP"
	echo "KO_CONN" | nc -q 1 $IP $PORT
	exit 1
else
	echo "Todo correcto"
	echo "OK_CONN" | nc -q 1 $IP $PORT
fi

echo "(5)Escuchando puerto $PORT"

HANDSHAKE=`nc -lp $PORT`

sleep 1

echo "(8)Comprobar y responder Handshake"

if [ "$HANDSHAKE" == "THIS_IS_MY_CLASSROOM" ]; then
	echo "Todo correcto"
	echo "YES_IT_IS" | nc -q 1 $IP $PORT
else
	echo "ERROR 2: No se ha recibido el Handshake correctamente"
	echo "ERROR 2" | nc -q 1 $IP $PORT
	exit 2
fi

echo "(9)Escuchando puerto $PORT"

#MSG=`nc -lp $PORT`

sleep 1

exit 0
