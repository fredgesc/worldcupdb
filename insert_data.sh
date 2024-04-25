#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
$PSQL "TRUNCATE games, teams"


cat games.csv | while IFS=, read -r year round winner opponent winner_goals opponent_goals;
do
  if [[ $year != "year" ]]
  then
    #Find winner_id
    WINNER_TEAM_ID=$($PSQL "select team_id from teams where team = '$winner'")

    if [[ -z "$WINNER_TEAM_ID" ]]
    then
      $PSQL "insert into teams(team) values ('$winner')"
      WINNER_TEAM_ID=$($PSQL "select team_id from teams where team = '$winner'")
      
    fi

    #Find opponent_id
    OPPONENT_TEAM_ID=$($PSQL "select team_id from teams where team = '$opponent'")
    
    if [[ -z "$OPPONENT_TEAM_ID" ]]
    then

      $PSQL "insert into teams(team) values ('$opponent')"
      OPPONENT_TEAM_ID=$($PSQL "select team_id from teams where team = '$opponent'")
      
    fi
    $PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($year, '$round', $WINNER_TEAM_ID, $OPPONENT_TEAM_ID, $winner_goals, $opponent_goals)"
  fi
done
