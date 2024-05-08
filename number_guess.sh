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
  if [[ $INSERT_USER_RESULT == 'INSERT 0 1' ]]
  then
    USER_ID=$($PSQL "select user_id from users where username = '$USERNAME';")
  fi
else
  GAMES_COUNT=$($PSQL "select count(*) from games where user_id = $USER_ID;")
  HIGH_SCORE=$($PSQL "select min(score) from games where user_id = $USER_ID;")
  echo -e "\nWelcome back, $USERNAME! You have played $GAMES_COUNT games, and your best game took $HIGH_SCORE guesses."
fi

SCORE=1
echo -e "\nGuess the secret number between 1 and 1000:"
read USER_GUESS

while [[ $USER_GUESS -ne $SECRET_NUM ]]
do
  ((SCORE++))

  if ! [[ $USER_GUESS =~ ^[0-9]+$ ]]
  then
    echo -e "\nThat is not an integer, guess again:"
    read USER_GUESS
  fi

  if [[ $USER_GUESS -gt $SECRET_NUM ]]
  then
    echo -e "\nIt's lower than that, guess again:"
    read USER_GUESS
  else
    echo -e "\nIt's higher than that, guess again:"
    read USER_GUESS
  fi
done

INSERT_GAME_RESULT=$($PSQL "insert into games(user_id, score) values($USER_ID, $SCORE);")

echo -e "\nYou guessed it in $SCORE tries. The secret number was $SECRET_NUM. Nice job!"
