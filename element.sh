#Get first argument

# DB Connection:
PSQL="psql --username=freecodecamp --dbname=periodic_table -t -c"

# If first argument is empty, output error
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."

else
  # check if argument is a number
  if [[ $1 =~ ^[0-9]+$ ]] 
  then
    # get the query by number
    ELEMENT_DATA=$($PSQL "select * FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE atomic_number=$1")
  
  # check if argument is a symbol
  elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
  then
    # get the query by symbol
    ELEMENT_DATA=$($PSQL "select * FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE symbol='$1'")
  # otherwise the argument is a string
  else
    # get the query by name
    ELEMENT_DATA=$($PSQL "select * FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE name='$1'")
  fi

  # Check if a result is found and if so, print data, otherwise a message
  if [[ -z $ELEMENT_DATA ]]
  then
    echo "I could not find that element in the database."
  else
    # Print out data in expected format
    echo "$ELEMENT_DATA" | while read TYPEID BAR ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi
