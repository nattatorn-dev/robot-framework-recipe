*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    Process
Library    OperatingSystem
Variables    ../environments/${env}.py
Resource    ./common.keyword.robot
Resource    ./common.variable.robot
