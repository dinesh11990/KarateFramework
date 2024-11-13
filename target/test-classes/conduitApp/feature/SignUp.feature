
Feature: Sign Up new user

Background: Preconditions
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * def randomEmail = dataGenerator.getRandomEmail()
    * def randomUsername = dataGenerator.getRandomUsername()
    * url apiUrl

Scenario: New user Sign Up
    #Embedded the expressions of -  email and username 
    #Given def userData = {"email":"test9031din@test.com", "username":"test90698din"}

    Given path 'users'
    #And request {"user":{"email": #('Test'+userData.email), "password": "test903321", "username": #('User'+userData.username)}}
    And request
    #Multiline expressions
    """
        {
        "user": {
        "email": #(randomEmail),
        "password": "dinesh123456",
        "username":  #(randomUsername)
                }
        }
    """
    When method Post
    Then status 201

    And match response ==

    """
        {
            "user": {
                "id": '#number',
                "email": #(randomEmail),
                "username": #(randomUsername),
                "bio": null,
                "image": "#string",
                "token": "#string"
            }
        }
    """

#Data Driven Scenario

Scenario Outline: Validate Sign Up error messages

    Given path 'users'
    #And request {"user":{"email": #('Test'+userData.email), "password": "test903321", "username": #('User'+userData.username)}}
    And request
    #Multiline expressions
    """
        {
        "user": {
            "email": "<email>",
            "password": "<password>",
            "username": "<username>"
                }
        }
    """
    When method Post
    Then status 422
    And match response == <errorResponse>

    Examples:

        | email              | password  | username               | errorResponse                                                                      |
        | #(randomEmail)     | ingenico1 | ingenico1231           | {"errors":{"username":["has already been taken"]}}                                 |
        | ingenico1@test.com | ingenico1 | #(randomUsername)      | {"errors":{"email":["has already been taken"]}}                                    |
        | KarateUser1        | Karate123 | #(randomUsername)      | {"errors":{"email":["is invalid"]}}                                                |
        | #(randomEmail)     | Karate123 | KarateUser123123123123 | {"errors":{"username":["is too long (maximum is 20 characters)"]}}                 | 
        | #(randomEmail)     | Kar       | #(randomUsername)      | {"errors":{"password":["is too short (minimum is 8 characters)"]}}                 | 
        |                    | Karate123 | #(randomUsername)      | {"errors":{"email":["can't be blank"]}}                                            | 
        | #(randomEmail)     |           | #(randomUsername)      | {"errors":{"password":["can't be blank"]}}                                         |
        | #(randomEmail)     | Karate123 |                        | {"errors":{"username":["can't be blank","is too short (minimum is 1 character)"]}} | 

            