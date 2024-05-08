#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
SECRET_NUM=$(echo $((1 + $RANDOM % 1000)))

echo "Enter your username:"
read USERNAME

USER_ID=$($PSQL "select user_id from users where username = '$USERNAME';")

if [[ -z $USER_ID ]]
then
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  INSERT_USER_RESULT=$($PSQL "insert into users (username) values ('$USERNAME');")
fi