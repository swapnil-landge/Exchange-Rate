package stepDefinations;

import org.junit.runner.RunWith;

import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.api.junit.Cucumber;
import io.restassured.RestAssured;
import io.restassured.response.Response;


	@RunWith(Cucumber.class)
	public class stepDefination {

		
		Response resp;
		
		@Given("^Rates API for Latest Foreign Exchange rates $")
	    public void rates_api_for_latest_foreign_exchange_rates() throws Throwable 
		{
			System.out.println("Rates API for Latest Foreign Exchange rates");

	    }

	    @When("^user check for the (.+) $")
	    public void user_check_for_the(String url) throws Throwable 
	    {
	    	Response resp = RestAssured.get(url);
	    }

	    @Then("^user verify the (.+) $")
	    public void user_verify_the(String status) throws Throwable 
	    {
	    	int code = resp.getStatusCode();

			System.out.println("Status Code is " +code);
	    	

	    }

	}