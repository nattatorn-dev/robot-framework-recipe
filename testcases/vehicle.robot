*** Settings ***
Documentation    Tests to create that vehicle succeed and
...              fail correctly 

Resource    ../resources/imports.robot
Resource    ../resources/authen/authen.keyword.robot

Suite Setup    Run Keywords
...    Session    AND
...    Login    ${ADMIN_USER}    ${ADMIN_PASSWORD}    AND
...    Prepare Test Data

Suite Teardown    Run Keywords
...    Logout
...    Remove ALL Testing License Plate On DB
...    Delete All Sessions

Test Timeout    10 s


*** Test Case ***
TC01 Create Vehicle Successfully
    [Tags]    sanity
    Create Vehicle Successfully

TC02_Find Vehicle Successfully
    Find Vehicle Successfully

***Keywords***
Prepare Test Data
    Create Testing License Plate On DB    ฮห 2231
    Create Testing License Plate On DB    ฟก 7673

Session
    [Documentation]    Create Session
    Create Session    Vehicle API    ${BASE_URL}    verify=True
    Set Suite Variable    ${session}    Vehicle API

Create Vehicle Successfully
    ${vehicle}=    Create Dictionary
    ...    licensePlate=AUTOMATION_TESTING_กฟ 1225
    ${headers}=    Create Dictionary    Content-Type=${CONTENT_TYPE_JSON}    
    ${response}=    Post Request    ${session}    uri=/vehicles
    ...    data=${vehicle}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    201

Find Vehicle Successfully
    ${headers}=    Create Dictionary    Content-Type=${CONTENT_TYPE_JSON}    
    ${response}=    Get Request    ${session}    uri=/vehicles
    ...    headers=${headers}

    Should Be Equal As Strings    ${response.status_code}    200
    ${count}=    Get length    ${response.json()}
    should be equal as numbers    ${count}    3

    ${vehicle}=    Set variable    ${response.json()[0]}
    ${licensePlate}=    Set variable    ${vehicle['licensePlate']}

    # Loop Wait Status Is Active Status     ${licensePlate}     Active
    Wait Status Is Active Status    ${licensePlate}    Active

Is Active Status
    [Arguments]    ${licensePlate}    ${status}
    ${currentStatus}    Find Status    ${licensePlate}
    Should Match    ${currentStatus}    ${status}

Wait Status Is Active Status
    [Arguments]    ${licensePlate}    ${status}
    Wait Until Keyword Succeeds    6 seconds    2 seconds    Check Status
    ...    ${licensePlate}    ${status}

# Loop Wait Status Is Active Status
#     [Timeout]    3 s
#     [Arguments]    ${licensePlate}    ${status}
#     FOR    ${i}    IN RANGE    999999
#     ${currentStatus}    Find Status    ${licensePlate}
#     Log To Console    ${currentStatus}
#     Exit For Loop If    "${currentStatus}" == "${status}"
#     END
#     Log    Check Active Status Exited