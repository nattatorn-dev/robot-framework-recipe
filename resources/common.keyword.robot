*** Settings ***
Library    MongoDBLibrary
Library    DateTime
Library    String
Library    Collections

*** Keywords ***
Create Testing License Plate On DB
    [Arguments]    ${licensePlate}
    ${now}=    Get Current Date    time_zone=UTC
    ${date}=    Convert Date    ${now}    result_format=%Y-%m-%d %H:%M:%S.%fZ
    ${query}=    Create Dictionary
    ...    licensePlate=AUTOMATION_TESTING_${licensePlate}
    ...    status=Active
    ...    createdAt=${date}
    ${query_string}=    evaluate    json.dumps(${query})
    Create Vehicle Records On DB    fleets    vehicles
    ...    ${query_string}

Remove Testing License Plate On DB
    [Arguments]    ${licensePlate}
    ${query}=    Create Dictionary
    ...    licensePlate=AUTOMATION_TESTING_${licensePlate}
    ${query_string}=    evaluate    json.dumps(${query})
    Remove Vehicle Records On DB    fleets    vehicles
    ...    ${query_string}

Check Status
    [Arguments]    ${licensePlate}    ${expectedStatus}
    Connect To MongoDB    ${MONGO_URI}
    Log    Check Active Status On DB
    ${fields}=    Retrieve Mongodb Records With Desired Fields    fleets    vehicles
    ...    {"licensePlate": "${licensePlate}"}    status    ${false}
    Comment    Disconnect from MongoDB Server
    Disconnect From Mongodb
    Should Contain    ${fields}    ${expectedStatus}

# Find Status
#     [Arguments]    ${licensePlate}
#     Connect To MongoDB    ${MONGO_URI}
#     Log    Check Active Status On DB
#     ${fields}=    Retrieve Mongodb Records With Desired Fields    fleets    vehicles
#     ...    {"licensePlate": "${licensePlate}"}    status    ${false}
#     Comment    Disconnect from MongoDB Server
#     Disconnect From Mongodb

#     ${dicItemRemoved}=    Remove String    ${fields}    dict_items
#     ${dict}=    evaluate    ast.literal_eval(${dicItemRemoved})
#     Log To Console    Test ${dict}
#     ${dicStructStartRemoved}=    Remove String    ${dicItemRemoved}    ([(
#     ${dicStructEndRemoved}=    Remove String    ${dicStructStartRemoved}    )])
#     ${singleQuote}=    Remove String    ${dicStructEndRemoved}    '
#     @{list}=    Split String    ${singleQuote}    ,
#     Remove Values from list    ${list}    ${EMPTY}
#     ${status}=    Set Variable    ${list[1].strip()}

#     [Return]    ${status}

Remove ALL Testing License Plate On DB
    ${search}=    Create Dictionary
    ...    $regex=AUTOMATION_TESTING
    ...    $options=i
    ${query}=    Create Dictionary
    ...    licensePlate=${search}
    ${query_string}=    evaluate    json.dumps(${query})
    Remove Vehicle Records On DB    fleets    vehicles
    ...    ${query_string}

Create Vehicle Records On DB
    [Timeout]    10 s
    [Arguments]    ${MONGO_DATABASE}    ${MONGO_COLLECTION}    ${query}
    Comment    Connect to MongoDB Server
    Connect To Mongodb    ${MONGO_URI}
    ${output}=    Save MongoDB Records    ${MONGO_DATABASE}    ${MONGO_COLLECTION}
    ...    ${query}
    Log    ${output}
    Comment    Disconnect from MongoDB Server
    Disconnect From Mongodb

Remove Vehicle Records On DB
    [Timeout]    10 s
    [Arguments]    ${MONGO_DATABASE}    ${MONGO_COLLECTION}    ${query}
    Comment    Connect to MongoDB Server
    Connect To Mongodb    ${MONGO_URI}
    ${output}=    Remove MongoDB Records    ${MONGO_DATABASE}    ${MONGO_COLLECTION}
    ...    ${query}
    Log    ${output}
    Comment    Disconnect from MongoDB Server
    Disconnect From Mongodb
