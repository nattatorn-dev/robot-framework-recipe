*** Settings ***
Variables    ../../environments/${env}.py
Resource    ../common.variable.robot

*** Keywords ***
Login
    [Arguments]    ${username}    ${password}
    Create Session    Authentication API    ${AUTHENTICATION_BASE_URL}    verify=True
    ${user}=    Create Dictionary
    ...    username=${username}
    ...    password=${password}
    ${headers}=    Create Dictionary    Content-Type=${CONTENT_TYPE_JSON}    
    ${response}=    Post Request    Authentication API    uri=/v1/auth/login
    ...    data=${user}    headers=${headers}    
    ${authen}=    Set variable    ${response.json()['data']}
    Set Suite Variable    ${token}    ${authen['token']}
    Set Suite Variable    ${refreshToken}    ${authen['refreshToken']}

Logout
    Create Session    Authentication API    ${AUTHENTICATION_BASE_URL}    verify=True
    ${headers}=    Create Dictionary    Content-Type=${CONTENT_TYPE_JSON}  
    ...    Authorization=${token}
    ${response}=    Post Request    Authentication API    uri=/v2/auth/logout
    ...    headers=${headers}

Find User
    Create Session    Authentication API    ${AUTHENTICATION_BASE_URL}    verify=True
    ${headers}=    Create Dictionary    Content-Type=${CONTENT_TYPE_JSON}  
    ...    Authorization=${token}
    ${response}=    Get Request    Authentication API    uri=/v2/sessions
    ...    headers=${headers}
    [Return]    ${response}
