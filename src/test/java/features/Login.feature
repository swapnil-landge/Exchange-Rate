@tag
Feature: Foreign Exchange Rates Feature


@tag1
  Scenario Outline: Foreign Exchange Rates Functionality with Currency and Date
    Given Rates API for Latest Foreign Exchange rates 
    When user check for the <url> 
    Then user verify the <status> 



Examples: 
      |                   url                       					  | status  |
      | https://api.ratesapi.io/api/latest?base=USD&symbols=GBP HTTP/2	  | success |
      | https://api.ratesapi.io/api/latest?base=USD&symbols=GBP HTTP/2    | OK      |
      |https://api.ratesapi.io/api/     		  						| Not Found |
      |https://api.ratesapi.io/api/2010-01-12       					  | success    |
      |https://api.ratesapi.io/api/2010-01-12     						    | ok    |
      |https://api.ratesapi.io/api/2021-15-11    					     | Unauthorized    |
      
    
 
