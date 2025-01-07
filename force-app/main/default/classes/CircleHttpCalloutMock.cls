public inherited sharing class CircleHttpCalloutMock implements HttpCalloutMock {
    private Map<String, HttpResponse> methodEndpointToResponse = new Map<String, HttpResponse>();

    public CircleHttpCalloutMock setResponse(HttpRequest req, HttpResponse res) {
        methodEndpointToResponse.put(getKey(req), res);
        return this;
    }

    public HttpResponse respond(HttpRequest req) {
        return methodEndpointToResponse.get(getKey(req));
    }

    public void mock() {
        Test.setMock(HttpCalloutMock.class, this);
    }

    private String getKey(HttpRequest req) {
        return req.getMethod() + '@' + req.getEndpoint();
    }
}
