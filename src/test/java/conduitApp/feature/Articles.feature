@debug
Feature: Articles

Background: Define URL
     * url apiUrl
     * def articleRequestBody = read('classpath:conduitApp/json/newArticleRequest.json')
    # * def tokenResponse = callonce read('classpath:helpers/CreateToken.feature') 
    # * def token = tokenResponse.authToken
    * def dataGenerator = Java.type('helpers.DataGenerator')
     * set articleRequestBody.article.title = dataGenerator.getRandomArticleValues().title
     * set articleRequestBody.article.description = dataGenerator.getRandomArticleValues().description
     * set articleRequestBody.article.body = dataGenerator.getRandomArticleValues().body


Scenario: Create a new article
    #Given header Authorization = 'Token ' + token
    Given path 'articles'
    And request articleRequestBody
    When method Post
    Then status 201
    And match response.article.title == articleRequestBody.article.title
    

Scenario: Create and delete article
    #Given header Authorization = 'Token ' + token
    Given path 'articles'
    And request articleRequestBody
    When method Post
    Then status 201
    * def articleId = response.article.slug

    Given param limit = 10
    Given param offset = 0
    Given path 'articles'
    When method Get
    Then status 200
    #And match response.articles[*].title == articleRequestBody.article.title

    #Given header Authorization = 'Token ' + token
    Given path 'articles',articleId
    When method Delete
    Then status 204

    Given param limit = 10
    Given param offset = 0
    Given path 'articles'
    When method Get
    Then status 200
    #And match response.articles[*].title !== articleRequestBody.article.title




    