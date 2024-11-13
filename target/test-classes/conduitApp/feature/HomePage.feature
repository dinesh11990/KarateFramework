
Feature: Tests for the home page

    Background: Define URL
    Given url apiUrl

    Scenario: Get all tags
        Given path 'tags'
        When method Get
        Then status 200

        #Below assertions are not madatory
        # And match response.tags contains ['Git','Test']
        # And match response.tags !contains 'truck'
        # And match response.tags contains any ['Data', 'Snow', 'Zoom']
        #And match response.tags !contains any ['Data', 'Snow']
        #And match response.tags contains only []

        #Below assertions are mandatory which verify the structure , array and string
        And match response.tags == "#array"
        And match each response.tags == "#string"

    Scenario: Get 10 articles from the page
        * def timeValidator = read ('classpath:helpers/timeValidator.js')

        Given param limit = 10
        Given param offset = 0
        Given path 'articles'
        When method Get
        Then status 200
        And match response.articles == '#[10]'

        ##Since we are using Schema Validation there is no need of below validation
        # And match response.articlesCount == 19
        # And match response.articlesCount != 199

        And match response == {"articles": "#array", "articlesCount":19}
        #We can use like this and skip  #And match response.articles == '#[10]'
        And match response == {"articles": "#[10]", "articlesCount":19}


        #Since we are using Schema Validation there is no need of below validation + Fuzzy matching
        And match response.articles[0].createdAt contains '2024'
        And match response.articles[*].favoritesCount contains 0
        #And match response.articles[*].author.bio contains null // Or you can use below one
        And match response..bio contains null
        And match each response..following == false

        #Fuzzy Matching
        And match each response..following == '#boolean'
        And match each response..favoritesCount == '#number'
        # Double hash verify the both null and string, even the key 'bio' is not there test will not fail
        And match each response..bio == '##string'


        #Schema Validation
        And match each response.articles ==
        """
            {
                "slug": "#string",
                "title": "#string",
                "description": "#string",
                "body": "#string",
                "tagList": "#array",
                "createdAt": "#? timeValidator(_)",
                "updatedAt": "#? timeValidator(_)",
                "favorited": '#boolean',
                "favoritesCount": '#number',
                "author": {
                    "username": "#string",
                    "bio": "##string",
                    "image": "#string",
                    "following": '#boolean'
                }
            }
        
        """