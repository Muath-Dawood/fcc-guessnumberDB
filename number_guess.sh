#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=numberGuess -t --no-align -c"
SECRET_NUM=$(echo $((1 + $RANDOM % 1000)))

read -p "Enter your username:" USERNAME
