Feature: Verify & Validate conversion rates for past and future dates using Foreign Exchange Rates API
  Description: Validate that Foreign Exchange Rates API for financial transactons 

  Background: 
    Given Foreign Exchange Rates API is accessible

  @Sanity @Regression
  Scenario Outline: Validate that API responds with correct status code 
    When API is hit with end point as "<Latest>" "<Symbols>" "<Base>"
    Then API Should respond with status code as "<StatusCode>"
    And Response should contain not null values for "<Base>"

    Examples: 
 |Latest                                    |Symbols                                                   | Base                                                    | StatusCode |
 |https://api.ratesapi.io/api/latest HTTP/2 |https://api.ratesapi.io/api/latest?symbols=USD,GBP HTTP/2 | https://api.ratesapi.io/api/latest?base=USD HTTP/2      | 200        |
 |https://api.ratesapi.io/api/latest HTTP/2 |https://api.ratesapi.io/api/latest?symbols=USD,GBP HTTP/2 | https://api.ratesapi.io/api/latest?base=USD,CAD HTTP/2  | 200        |
 |https://api.ratesapi.io/api/latest HTTP/2 |https://api.ratesapi.io/api/latest?symbols=USD,GBP HTTP/2 | https://api.ratesapi.io/api/latest?base=USD HTTP/2      |        200 |
 | 2020-10-07                       | https://api.ratesapi.io/api/latest?symbols=USD,GBP HTTP/2       | https://api.ratesapi.io/api/latest?base=RUB HTTP/2       |        200 |
 | 2020-08-25 | https://api.ratesapi.io/api/latest?symbols=USD,GBP HTTP/2    | https://api.ratesapi.io/api/latest?base=USD,GBP HTTP/2      |        200 |

  @Sanity @Regression
  Scenario Outline: Validate API responds with correct base value with currency 
    When API is hit with end point as "<Latest>" "<Symbols>" "<Base>"
    Then API Should respond with status code as "200"
    And Response should contain base currency as "<Base>"
    And Response should contain value "1.0" for "<Base>"
    And Response should contain not null values for "<Currencies>"

    Examples: 
      | Latest                                      | Symbols                                                  | Base         | Currencies |
      | https://api.ratesapi.io/api/latest HTTP/2   | https://api.ratesapi.io/api/latest?base=USD HTTP/2       | GBP          | CAD,AUD         |
      | https://api.ratesapi.io/api/latest HTTP/2    |https://api.ratesapi.io/api/latest?base=USD HTTP/2       | RUB          | PHP,AUD         |
      | https://api.ratesapi.io/api/latest HTTP/2    | https://api.ratesapi.io/api/latest?base=USD HTTP/2       | AUD          | INR,USD         |
      | https://api.ratesapi.io/api/latest HTTP/2    | https://api.ratesapi.io/api/latest?base=USD HTTP/2       | USD          | RUB,AUD         |
      | https://api.ratesapi.io/api/latest HTTP/2    | https://api.ratesapi.io/api/latest?base=USD HTTP/2       | NZD          | INR,AUD         |

  @InvalidEndpoint @Sanity @Regression
  Scenario Outline: Validate results when invalid endpoint
    When API is hit with end point as ?base="<EndPoint>"
    Then API Should respond with status code as "<StatusCode>"
    And Error message should be displayed as "<ErrorMessage>"

    Examples: 
      | EndPoint | StatusCode | ErrorMessage                 |
      | ABC      |        400 | Base Currency is not supported. |
      | D13      |        400 | Base Currency is not supported. |
      | !%&      |        400 | Base Currency is not supported. |

  @PastConversionRates @Sanity @Regression
  Scenario Outline: Validate that API returns data for past date
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
  Scenario Outline: Validate that API returns data for future date
    When API is hit with end point as "<EndPoint>" "<QueryParam>" "<BaseCurrency>"
    Then API Should respond with status code as "200"
    And Response should contain date as "<ResponseDate>"
    And Response for future date should match with response for today
    And Response should contain not null values for "<CheckCurrencies>"

    Examples: 
      | EndPoint   | QueryParam | BaseCurrency | ResponseDate | CheckCurrencies |
      | 2020-06-03 | base       | EUR          | Today        | NZD,INR         |
      | 2020-12-31 | base       | JPY          | Today        | USD,CHF         |
