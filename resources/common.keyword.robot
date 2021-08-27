*** Settings ***
Library    MongoDBLibrary

*** Keywords ***
Create Testing License Plate On DB
    [Arguments]    ${licensePlate}
    ${query}=    Create Dictionary
    ...    licensePlate=AUTOMATION_TESTING_${licensePlate}
    ${query_string}=      evaluate        json.dumps(${query})
    Create Vehicle Records On DB    fleets    vehicles
    ...    ${query_string}

Remove Testing License Plate On DB
    [Arguments]    ${licensePlate}
    ${query}=    Create Dictionary
    ...    licensePlate=AUTOMATION_TESTING_${licensePlate}
    ${query_string}=      evaluate        json.dumps(${query})
    Remove Vehicle Records On DB    fleets    vehicles
    ...    ${query_string}

Remove ALL Testing License Plate On DB
    ${search}=    Create Dictionary
    ...    $regex=AUTOMATION_TESTING
    ...    $options=i
    ${query}=    Create Dictionary
    ...    licensePlate=${search}
    ${query_string}=      evaluate        json.dumps(${query})
    Remove Vehicle Records On DB    fleets    vehicles
    ...    ${query_string}

Create Vehicle Records On DB
    [Arguments]    ${MONGO_DATABASE}    ${MONGO_COLLECTION}    ${query}
    Comment    Connect to MongoDB Server
    Connect To Mongodb    ${MONGO_URI}
    ${output}=    Save MongoDB Records    ${MONGO_DATABASE}    ${MONGO_COLLECTION}
    ...    ${query}
    Log    ${output}
    Comment    Disconnect from MongoDB Server
    Disconnect From Mongodb

Remove Vehicle Records On DB
    [Arguments]    ${MONGO_DATABASE}    ${MONGO_COLLECTION}    ${query}
    Comment    Connect to MongoDB Server
    Connect To Mongodb    ${MONGO_URI}
    ${output}=    Remove MongoDB Records    ${MONGO_DATABASE}    ${MONGO_COLLECTION}
    ...    ${query}
    Log    ${output}
    Comment    Disconnect from MongoDB Server
    Disconnect From Mongodb
