*** Settings ***
Documentation    Vehicle
Resource    ../resources/imports.robot
Test Setup    Setup
Test Teardown    Teardown
Test Timeout    10 s



*** Test Case ***
TC01 Create Vehicle Successfully
    [Tags]    sanity
    Create Vehicle Successfully



***Keywords***
Setup
    Session
    Create Testing License Plate On DB    TC01_01
    Create Testing License Plate On DB    TC01_02
    Create Testing License Plate On DB    TC01_03
    Create Testing License Plate On DB    TC01_04

Teardown
    Remove ALL Testing License Plate On DB
    Delete All Sessions

Session
    [Documentation]    Create Session
    Create Session    Vehicle    ${BASE_URL}    verify=True
    Set Suite Variable    ${session}    Vehicle

Create Vehicle Successfully
    Comment    TODO: Implement Create Vehicle Successfully
