Feature: Verify & Validate conversion rates for past and future dates using Foreign Exchange Rates API
  Description: Validate that Foreign Exchange Rates API for financial transactons 

  Background: 
    Given Foreign Exchange Rates API is accessible

  @Sanity @Regression
  Scenario Outline: Validate that API responds with correct status code 
    When API is hit with end point as "<EndPoint>" "<QueryParam>" "<BaseCurrency>"
    Then API Should respond with status code as "<StatusCode>"
    And Response should contain not null values for "<BaseCurrency>"

    Examples: 
      | EndPoint   | QueryParam | BaseCurrency | StatusCode |
      | latest     | symbols    | GBP          |        200 |
      | latest     | symbols    | USD,CAD      |        200 |
      | latest     | base       | USD          |        200 |
      | 2020-05-03 | base       | RUB          |        200 |
      | 2020-06-15 | symbols    | USD,GBP      |        200 |

  @Sanity @Regression
  Scenario Outline: Validate API responds with correct base value with currency based input
    When API is hit with end point as "<EndPoint>" "<QueryParam>" "<BaseCurrency>"
    Then API Should respond with status code as "200"
    And Response should contain base currency as "<BaseCurrency>"
    And Response should contain value "1.0" for "<BaseCurrency>"
    And Response should contain not null values for "<CheckCurrencies>"

    Examples: 
      | EndPoint | QueryParam | BaseCurrency | CheckCurrencies |
      | latest   | base       | GBP          | INR,AUD         |
      | latest   | base       | RUB          | PHP,AUD         |
      | latest   | base       | AUD          | INR,USD         |
      | latest   | base       | USD          | INR,AUD         |
      | latest   | base       | NZD          | INR,AUD         |

  @InvalidEndpoint @Sanity @Regression
  Scenario Outline: Validate results when incorrect/invalid endpoint is invoked
    When API is hit with end point as ?base="<EndPoint>"
    Then API Should respond with status code as "<StatusCode>"
    And Error message should be displayed as "<ErrorMessage>"

    Examples: 
      | EndPoint | StatusCode | ErrorMessage                 |
      | BKG      |        400 | Base 'BKG' is not supported. |
      | 123      |        400 | Base '123' is not supported. |
      | @#$      |        400 | Base '@#$' is not supported. |

  @PastConversionRates @Sanity @Regression
  Scenario Outline: Validate that API returns data for specific past date
    When API is hit with end point as "<EndPoint>" "<QueryParam>" "<BaseCurrency>"
    Then API Should respond with status code as "200"
    And Response should contain date as "<ResponseDate>"
    And Response should contain not null values for "<CheckCurrencies>"
    And Response should contain base currency as "<BaseCurrency>"

    Examples: 
      | EndPoint   | QueryParam | BaseCurrency | ResponseDate | CheckCurrencies |
      | 2020-06-01 | base       | INR          | 2020-06-01   | AUD,GBP         |
      | 2020-05-31 | base       | USD          | 2020-05-31   | NZD,INR         |
      | 2019-12-31 | base       | EUR          | 2019-12-31   | EUR,JPY         |

  @FutureConversionRates @Sanity @Regression
  Scenario Outline: Validate that API returns data for today when queried for a future date
    When API is hit with end point as "<EndPoint>" "<QueryParam>" "<BaseCurrency>"
    Then API Should respond with status code as "200"
    And Response should contain date as "<ResponseDate>"
    And Response for future date should match with response for today
    And Response should contain not null values for "<CheckCurrencies>"

    Examples: 
      | EndPoint   | QueryParam | BaseCurrency | ResponseDate | CheckCurrencies |
      | 2020-06-03 | base       | EUR          | Today        | NZD,INR         |
      | 2020-12-31 | base       | JPY          | Today        | USD,CHF         |
