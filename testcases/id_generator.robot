*** Settings ***
Documentation       ID Generator API
Library             ../lib/RequestLib.py
Resource            ../resources/imports.robot
Test Setup            Session
Test Teardown         Delete All Sessions


*** Variables ***
#ENDPOINTS              ---
${CONFIGURATIONS}       /v1/configurations
${GENERATORS}           /v1/generators


#HEADERS                ---
${CONTENT_TYPE_JSON}    application/json

#GENERATOR DETAILS       ---
${CONFIGURATION_NAME}    idGeneratorConfig
${WFM_INSTALLATION_PROJECT}    5cf0ad79b603c7605955bc7f
${ODM_SENDIT_COURIER_PROJECT}    5ec797eaf3a41244b903ade1
${TASK}    task



***Test Cases***
TC_01 Upload configuration by .csv file should success
    [Tags]  Sanity
    Upload configuration by .csv file

TC_02 get configuration by name should success
    Get configuration by name

TC_03 Get factor of ID Generator by request should success
    Get factor of ID Generator by request

TC_04 Clear configuration cache should success
    Clear configuration cache

TC_05 Generate ID should success
    [Tags]  Sanity
    Generate ID should success

TC_06 Generate ID with invalid data request should fail
    [Tags]  Sanity
    Generate ID with invalid data request should fail

***Keywords***
Session
    [Documentation]       Create Session
    Create Session        ID Generator API    ${BASE_URL}    verify=True
    Set Suite Variable    ${session}      ID Generator API


Ping Server
    ${response}=        Get Request    ping    uri=/system/health 
    Should Be Equal As Strings    ${response.status_code}    200


Upload configuration by .csv file
    ${response}=        upload_file    ${BASE_URL}${CONFIGURATIONS}/upload/csv    configuration.csv    ${CURDIR}${/}testdata${/}configuration.csv    text/csv
    Should Be Equal As Strings    ${response.status_code}    200


Get configuration by name
    ${response}=        Get Request     ${session}    uri=${CONFIGURATIONS}    params=name=${CONFIGURATION_NAME}
    Should Be Equal As Strings    ${response.status_code}    200
    Should Be Equal As Strings    ${CONFIGURATION_NAME}    ${response.json()}[name]


Get factor of ID Generator by request
    ${requestGenerator}=        Create Dictionary
    ...                         type=${TASK}
    ...                         projectId=${ODM_SENDIT_COURIER_PROJECT}
    ${HEADERS}=          Create Dictionary
    ...                  Content-Type=${CONTENT_TYPE_JSON}
    ${response}=      Post Request     ${session}    uri=${CONFIGURATIONS}/test    params=name=${CONFIGURATION_NAME}    data=${requestGenerator}    headers=${HEADERS}
    Should Be Equal As Strings    ${response.status_code}    200
    Element should exist    ${response.content}    .component1:contains("date('YY')")
    Element should exist    ${response.content}    .component2:contains("'SEND'")
    Element should exist    ${response.content}    .component3:contains("'-TA'")
    Element should exist    ${response.content}    .component4:contains("hashSequence('SEND')")


Clear configuration cache
    ${response}=      Post Request     ${session}    uri=${CONFIGURATIONS}/clear    params=name=${CONFIGURATION_NAME}
    Should Be Equal As Strings    ${response.status_code}    200


Generate ID should success
    ${data}=            Create Dictionary
    ...                 projectId=${WFM_INSTALLATION_PROJECT}
    ${requestGenerator}=        Create Dictionary
    ...                         type=${TASK}
    ...                         data=${data}
    ${response}=        Generate ID     ${requestGenerator}     200
    Element should exist    ${response.content}    .id


Generate ID with invalid data request should fail
    ${data}=            Create Dictionary
    ...                 projectId=${WFM_INSTALLATION_PROJECT}
    ${requestGenerator}=        Create Dictionary
    ...                         type=${EMPTY}
    ${response}=        Generate ID     ${requestGenerator}     400
    Element should not exist    ${response.content}    .id


Generate ID
    [Arguments]    ${data}    ${expected_status_code}
    ${HEADERS}=          Create Dictionary
    ...                  Content-Type=${CONTENT_TYPE_JSON}
    ${response}=      Post Request     ${session}     uri=${GENERATORS}    data=${data}    headers=${HEADERS}
    Should Be Equal As Strings    ${response.status_code}    ${expected_status_code}
    [Return]    ${response}