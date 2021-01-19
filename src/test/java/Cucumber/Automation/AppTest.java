package Cucumber.Automation;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;


import java.util.LinkedHashMap;
import org.apache.log4j.Logger;
import org.junit.Assert;

import io.cucumber.core.api.Scenario;
import io.restassured.RestAssured;
import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;
import io.restassured.response.ResponseBody;
import io.restassured.specification.RequestSpecification;
import utils.LoggerHelper;


/**
 * Unit test for simple App.
 */
public class AppTest {
    
    // Member variables
	protected RequestSpecification httpRequest;
	protected String bodyAsString;
	protected ResponseBody<?> body;
	protected Response response;
	protected int actStatusCode;
	protected Scenario scn=null;
	public static Logger logger;

	// Constructor that fetches logger object
	public TestBase() {
		logger = LoggerHelper.getLogger(LoggerHelper.class);
	}

	// Get response
	public Response getResponse() {
		return response;
	}

	// Get JsonPath for response
	public JsonPath getJsonPath() {
		return response.jsonPath();
	}

	// Fetch rates HashMap from the response
	public LinkedHashMap<String, String> getResponseMap() {
		return new LinkedHashMap<String, String>(getJsonPath().getMap("rates"));
	}

	// *************************************************************************************************************************************
	// Function:isAPIAccessible()
	// Objective:Health check for API by validating response status code
	// Usage:isAPIAccessible(baseURI,200)
	// *************************************************************************************************************************************
	public void isAPIAccessible(String baseURI, int expStatusCode) {
		logger.info("Checking if API '" + baseURI + "' is accessible");
		try {
			// Setup Requestspecification object
			RestAssured.baseURI = baseURI;
			httpRequest = RestAssured.given();

			// Get response
			response = httpRequest.get();
			actStatusCode = response.getStatusCode();

			// log status code and response
			logger.info("API response received : " + response.asString());
			logger.info("Response Status code '" + actStatusCode + "'");

			// Assert that expected and actual status codes match
			Assert.assertEquals(expStatusCode, actStatusCode);
			logger.info("API '" + baseURI + "' is accessible");
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("Exception caught : " + e.getMessage());
			throw new RuntimeException("TestBase::isAPIAccessible() -> Exception caught : " + e.getMessage()); 
		}
	}

	// *************************************************************************************************************************************
	// Function:hitEndpoint()
	// Objective:Hit plain endpoint without query parameters and capture response
	// Usage:hitEndpoint(baseURI+"2020-06-02"
	// *************************************************************************************************************************************
	public void hitEndpoint(String endPoint) {
		logger.info("Hitting endpoint '" + endPoint + "'");
		try {
			// Setup Requestspecification object
			RestAssured.baseURI = endPoint;
			httpRequest = RestAssured.given();

			// Get response
			response = httpRequest.get();
			body = response.getBody();
			actStatusCode = response.getStatusCode();

			// log response
			bodyAsString = body.asString();
			logger.info("Response received : " + bodyAsString);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("Exception caught : " + e.getMessage());
			throw new RuntimeException("TestBase::hitEndpoint() -> Exception caught : " + e.getMessage());
		}
	}

	// *************************************************************************************************************************************
	// Function:hitEndpoint()
	// Objective:Hit an endpoint with query parameters and capture response
	// Usage:hitEndpoint(baseURI+"2020-06-02"
	// *************************************************************************************************************************************
	public void hitEndpoint(String endPoint, String queryParamField, String queryParamValue) {
		logger.info(
				"Hitting endpoint '" + endPoint + "', queryParams '" + queryParamField + "," + queryParamValue + "'");
		try {
			// Setup Requestspecification object
			RestAssured.baseURI = endPoint;
			httpRequest = RestAssured.given();

			// Setup query parameters
			response = httpRequest.queryParam(queryParamField, queryParamValue).get();

			// Get response and status code
			body = response.getBody();
			bodyAsString = body.asString();
			actStatusCode = response.getStatusCode();

			// log response and status code
			logger.info("Response received : " + bodyAsString);
			logger.info("Response status code : '" + actStatusCode + "'");
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("Exception caught : " + e.getMessage());
			throw new RuntimeException("TestBase::hitEndpoint() -> Exception caught : " + e.getMessage());
		}
	}
}
   
