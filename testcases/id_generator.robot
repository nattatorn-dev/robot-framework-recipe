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
TC_01 UPLOAD CONFIGURATION BY .CSV FILE
    [Documentation]    To upload configuration by .csv file work success
    [Tags]  Sanity
    UPLOAD CONFIGURATION BY .CSV FILE

TC_02 GET CONFIGURATION BY NAME
    GET CONFIGURATION BY NAME

TC_03 GET FACTOR OF ID GENERATOR BY REQUEST
    GET FACTOR OF ID GENERATOR BY REQUEST

TC_04 Generate ID
    [Documentation]    To generate id work success
    [Tags]  Sanity
    Generate ID



***Keywords***
Session
    [Documentation]       Create Session
    Create Session        ID Generator API    ${BASE_URL}    verify=True
    Set Suite Variable    ${session}      ID Generator API


Ping Server
    ${response}=        Get Request    ping    uri=/system/health 
    Should Be Equal As Strings    ${response.status_code}    200


UPLOAD CONFIGURATION BY .CSV FILE
    ${response}=        upload_file    ${BASE_URL}${CONFIGURATIONS}/upload/csv    configuration.csv    ${CURDIR}${/}testdata${/}configuration.csv    text/csv
    Should Be Equal As Strings    ${response.status_code}    200


GET CONFIGURATION BY NAME
    ${response}=        Get Request     ${session}    uri=${CONFIGURATIONS}    params=name=${CONFIGURATION_NAME}
    Should Be Equal As Strings    ${response.status_code}    200
    Should Be Equal As Strings    ${CONFIGURATION_NAME}    ${response.json()}[name]


GET FACTOR OF ID GENERATOR BY REQUEST
    ${requestGenerator}=        Create Dictionary
    ...                         type=${TASK}
    ...                         projectId=${ODM_SENDIT_COURIER_PROJECT}
    ${HEADERS}=          Create Dictionary
    ...                  Content-Type=${CONTENT_TYPE_JSON}
    ${response}=      Post Request     ${session}    uri=${CONFIGURATIONS}/test    params=name=${CONFIGURATION_NAME}    data=${requestGenerator}    headers=${HEADERS}
    Should Be Equal As Strings    ${response.status_code}    200
    Element should exist    ${response.content}    .component1:contains("date('YY')")


Generate ID
    ${data}=            Create Dictionary
    ...                 projectId=${WFM_INSTALLATION_PROJECT}
    ${requestGenerator}=        Create Dictionary
    ...                         type=${TASK}
    ...                         data=${data}
    ${HEADERS}=          Create Dictionary
    ...                  Content-Type=${CONTENT_TYPE_JSON}
    ${response}=      Post Request     ${session}    uri=${GENERATORS}    data=${requestGenerator}    headers=${HEADERS}
    Should Be Equal As Strings    ${response.status_code}    200
    Element should exist    ${response.content}    .id
