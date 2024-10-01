#!/bin/bash

#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

echo -e "\nWelcome to the Salon Scheduler!"

# Function to display services
display_services() {
  echo -e "\nHere are the available services:"
  SERVICES=$($PSQL "SELECT service_id, name FROM services")
  echo "$SERVICES" | while IFS="|" read SERVICE_ID SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
}

# Function to validate the service selection
get_service_id() {
  read SERVICE_ID_SELECTED
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

  # Check if the service exists
  while [[ -z $SERVICE_NAME ]]
  do
    echo -e "\nInvalid service number. Please try again."
    display_services
    read SERVICE_ID_SELECTED
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  done
}

# Display services initially
display_services

# Prompt for service selection and validate it
echo -e "\nPlease select a service by entering the service number:"
get_service_id

# Get customer phone number
echo -e "\nEnter your phone number:"
read CUSTOMER_PHONE

# Check if customer exists
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
if [[ -z $CUSTOMER_NAME ]]; then
  echo -e "\nIt seems you're a new customer. What is your name?"
  read CUSTOMER_NAME
  # Add new customer to the database
  INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers (name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
else
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
fi

# Get appointment time
echo -e "\nEnter the time for your appointment (e.g., '10:30 AM'):"
read SERVICE_TIME

# Insert appointment into the database
INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

# Confirm appointment
echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."