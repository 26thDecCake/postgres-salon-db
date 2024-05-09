#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

AVAILABLE_SERVICES=$($PSQL "select service_id, name from services order by service_id")

STORE_NAME="\n~~~~~ MY SALON ~~~~~\n"
STORE_HEADER="Welcome to My Salon, how can I help you?\n"
echo -e $STORE_NAME
echo -e $STORE_HEADER

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  if [[ -z $AVAILABLE_SERVICES ]]
  then
    MAIN_MENU "Sorry, we are closed."
  else
    echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
    do
      echo "$SERVICE_ID) $SERVICE_NAME"
    done

    read SERVICE_ID_SELECTED
    if [[ $SERVICE_ID_SELECTED -lt 1 || $SERVICE_ID_SELECTED -gt 5 ]]
    then
      # MAIN_MENU "I could not find that service. What would you like today?"

      echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
      do
        echo "$SERVICE_ID) $SERVICE_NAME"
      done
      read SERVICE_ID_SELECTED
    fi

    SERVICE_NAME_SELECTED=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")

    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE

    CUSTOMER_NAME=$($PSQL "select name from customers WHERE phone = '$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME

      INSERT_CUSTOMER_RESULT=$($PSQL "insert into customers(name, phone) values('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
      if [[ -z $INSERT_CUSTOMER_RESULT ]]
      then
        MAIN_MENU "Welcome to My Salon, how can I help you?"
      fi
    fi

    echo -e "\nWhat time would you like your $(echo $SERVICE_NAME_SELECTED | sed -r 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')?"
    read SERVICE_TIME

    CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
    INSERT_APPOINTMENT_RESULT=$($PSQL "insert into appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    
    echo -e "\nI have put you down for a $SERVICE_NAME_SELECTED at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
  fi

}




MAIN_MENU