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


public class AppTest {
    
    // Member variables
	protected RequestSpecification httpRequest;
	protected String bodyAsString;
	protected ResponseBody<?> body;
	protected Response response;
	protected int actStatusCode;
	protected Scenario scn=null;
	public static Logger logger;

	
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
	// Check for API validating response status code
	// *************************************************************************************************************************************
	public void isAPIAccessible(String baseURI, int expStatusCode) {
		try {
			// Setup Requestspecification object
			RestAssured.baseURI = baseURI;
			httpRequest = RestAssured.given();

			// Get response
			response = httpRequest.get();
			actStatusCode = response.getStatusCode();

			
			// Assert that expected and actual status codes match
			Assert.assertEquals(expStatusCode, actStatusCode);
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("AppTest::isAPIAccessible() -> Exception caught : " + e.getMessage()); 
		}
	}

	// *************************************************************************************************************************************
	// Endpoint without query parameters and capture response
	// *************************************************************************************************************************************
	public void hitEndpoint(String endPoint) {

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
			
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("AppTest::hitEndpoint() -> Exception caught : " + e.getMessage());
		}
	}

	// *************************************************************************************************************************************
	// Endpoint with query parameters and capture response
	// *************************************************************************************************************************************
	public void hitEndpoint(String endPoint, String queryParamField, String queryParamValue) {
		
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


		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("AppTest::hitEndpoint() -> Exception caught : " + e.getMessage());
		}
	}
}
