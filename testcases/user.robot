*** Settings ***
Resource    ../resources/imports.robot
Resource    ../resources/authen/authen.keyword.robot

Suite Setup    Login    ${ADMIN_USER}    ${ADMIN_PASSWORD}

Suite Teardown    Run Keywords
...    Logout
...    Delete All Sessions


*** Test Case ***
TC01 Find User
    ${user}    Find User
    Should Be Equal As Strings    ${user.status_code}    200