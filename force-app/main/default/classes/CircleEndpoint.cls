public with sharing class CircleEndpoint {
    public static final String endpointUrl = 'https://api.circle.com';
    public static final String apiVersion = 'v1';
    public static final String endpointFix = 'w3s';

    public HttpRequest request;
    public HTTPResponse response;

    public CircleEndpoint() {
        request = new HttpRequest();
    }

    public CircleEndpoint get() {
        request.setMethod('GET');
        return this;
    }

    public CircleEndpoint post() {
        request.setMethod('POST');
        return this;
    }

    public CircleEndpoint setEndpoint(String value) {
        request.setEndpoint(String.join(new List<String>{ endpointUrl, apiVersion, endpointFix }, '/') + value);
        return this;
    }

    public CircleEndpoint setHeaders(Map<String, String> nameToValue) {
        for (String name : nameToValue.keySet()) {
            request.setHeader(name, nameToValue.get(name));
        }
        return this;
    }

    public CircleEndpoint setBody(String value) {
        request.setBody(value);
        return this;
    }

    public CircleEndpoint send() {
        Http http = new Http();
        response = http.send(request);
        return this;
    }

    public HTTPResponse getResponse() {
        return response;
    }

    public Integer getStatusCode() {
        return response.getStatusCode();
    }

    public Object deserializeBody(System.Type type) {
        return JSON.deserialize(response.getBody(), type);
    }

    public class CircleAPIException extends Exception {
    }
}
