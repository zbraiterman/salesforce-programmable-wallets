public with sharing class TestDataFactory {
    public static ProgrammableWalletsSetting__c createSettings() {
        ProgrammableWalletsSetting__c settings = new ProgrammableWalletsSetting__c();
        settings.Identifier__c = ProgrammableWalletsService.IDENTIFIER;
        settings.ApiKey__c = 'test_api_key';
        settings.ConsoleRegistered__c = true;
        settings.EntitySecret__c = 'test_entity_secret';
        settings.EntityPublicKey__c = 'test_entity_public_key';
        settings.EntitySecretCiphertext__c = 'test_entity_secret_ciphertext';
        insert as system settings;

        return settings;
    }

    public static void setEntityPublicKeyMock(String publicKey, Integer statusCode) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.circle.com/v1/w3s/config/entity/publicKey');
        req.setMethod('GET');

        Map<String, Object> body = new Map<String, Object>{ 'data' => new Map<String, Object>{ 'publicKey' => publicKey } };

        HttpResponse res = new HttpResponse();
        res.setStatusCode(statusCode);
        res.setBody(JSON.serialize(body));

        new CircleHttpCalloutMock().setResponse(req, res).mock();
    }
}
