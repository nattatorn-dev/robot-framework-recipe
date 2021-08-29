*** Settings ***
Documentation    Vehicle
Resource    ../resources/imports.robot
Suite Setup    Setup
Suite Teardown    Teardown
Test Timeout    10 s



*** Test Case ***
TC01 Create Vehicle Successfully
    [Tags]    sanity
    Create Vehicle Successfully

TC02_Find Vehicle Successfully
    Find Vehicle Successfully

***Keywords***
Setup
    Session
    Create Testing License Plate On DB    ฮห 2231
    Create Testing License Plate On DB    ฟก 7673

Teardown
    Remove ALL Testing License Plate On DB
    Delete All Sessions

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
    should be equal as numbers  ${count}  3