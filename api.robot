*** Settings ***
Documentation       API Test
Test Timeout        1 minute
Library             RequestsLibrary
Library             Collections
Library             JsonValidator
Library             Process
Library             OperatingSystem
Library             lib/RequestLib.py
Suite Setup         Ping Server



*** Variables ***
#ENDPOINTS              ---
${BASE_URL}             http://localhost
${CONFIGURATIONS}       /v1/configurations
${GENERATORS}           /v1/generators


#HEADERS                ---
${CONTENT_TYPE_JSON}    application/json

#GENERATOR DETAILS       ---
${CONFIGURATION_NAME}    idGeneratorConfig
${WFM_INSTALLATION_PROJECT}    5cf0ad79b603c7605955bc7f
${TASK}    task



***Test Cases***
UPLOAD CONFIGURATION BY .CSV FILE
    [Tags]  POST
    UPLOAD CONFIGURATION BY .CSV FILE

GET CONFIGURATION BY NAME
    [Tags]  GET
    GET CONFIGURATION BY NAME

Generate ID
    [Tags]  POST
    Generate ID



***Keywords***
Ping Server
    Create Session      ping    ${BASE_URL}    verify=True
    ${response}=        Get Request    ping    uri=/system/health 
    Should Be Equal As Strings    ${response.status_code}    200


UPLOAD CONFIGURATION BY .CSV FILE
    Create Session      Upload configuration by .csv file    ${BASE_URL}    verify=True
    ${response}=        upload_file    ${BASE_URL}${CONFIGURATIONS}/upload/csv    configuration.csv    ${CURDIR}${/}devData${/}configuration.csv    text/csv
    Should Be Equal As Strings    ${response.status_code}    200


GET CONFIGURATION BY NAME
    Create Session      Get configuration by name    ${BASE_URL}    verify=True
    ${response}=        Get Request    Get configuration by name    uri=${CONFIGURATIONS}    params=name=${CONFIGURATION_NAME}
    Should Be Equal As Strings    ${response.status_code}    200
    Should Be Equal As Strings    ${CONFIGURATION_NAME}    ${response.json()}[name]


Generate ID
    ${data}=            Create Dictionary
    ...                 projectId=${WFM_INSTALLATION_PROJECT}
    ${requestGenerator}=        Create Dictionary
    ...                         type=${TASK}
    ...                         data=${data}
    ${HEADERS}=          Create Dictionary
    ...                  Content-Type=${CONTENT_TYPE_JSON}
    ...                  User-Agent=RobotFramework
    Create Session    Generate id    ${BASE_URL}    verify=True
    ${response}=      Post Request    Generate ID    uri=${GENERATORS}    data=${requestGenerator}    headers=${HEADERS}
    Should Be Equal As Strings    ${response.status_code}    200
    Element should exist    ${response.content}    .id
