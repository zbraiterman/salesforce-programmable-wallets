@isTest
public with sharing class TestDataFactory {
    public static ProgrammableWalletsSetting__c createSettings() {
        ProgrammableWalletsSetting__c settings = new ProgrammableWalletsSetting__c();
        settings.Identifier__c = ProgrammableWalletsService.IDENTIFIER;
        settings.ApiKey__c = 'test_api_key';
        settings.ConsoleRegistered__c = true;
        settings.EntitySecret__c = 'test_entity_secret';
        settings.EntityPublicKey__c = 'test_entity_public_key';
        settings.EntitySecretCiphertext__c = 'test_entity_secret_ciphertext';
        insert as user settings;

        return settings;
    }

    public static WalletSet__c createWalletSet() {
        WalletSet__c walletSet = new WalletSet__c();
        walletSet.CircleId__c = 'test_circle_id';
        walletSet.CircleName__c = 'test_name';
        walletSet.CustodyType__c = 'test_custody_type';
        insert as user walletSet;

        return walletSet;
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

    public static void setCreateWalletSetMock(String name, Integer statusCode) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.circle.com/v1/w3s/developer/walletSets');
        req.setMethod('POST');

        Map<String, Object> body = new Map<String, Object>{
            'data' => new Map<String, Object>{
                'walletSet' => new Map<String, Object>{ 'id' => 'test_id', 'custodyType' => 'test_custody_type', 'name' => name }
            }
        };

        HttpResponse res = new HttpResponse();
        res.setStatusCode(statusCode);
        res.setBody(JSON.serialize(body));

        new CircleHttpCalloutMock().setResponse(req, res).mock();
    }

    public static void setCreateWalletMock(String name, Integer statusCode) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.circle.com/v1/w3s/developer/wallets');
        req.setMethod('POST');

        Map<String, Object> body = new Map<String, Object>{
            'data' => new Map<String, Object>{
                'wallets' => new List<Object>{
                    new Map<String, Object>{
                        'id' => 'test_id',
                        'address' => 'test_address',
                        'blockchain' => 'EVM',
                        'custodyType' => 'test_custodyType',
                        'name' => name,
                        'state' => 'test_state',
                        'userId' => 'test_user_id',
                        'walletSetId' => 'test_wallet_set_id',
                        'initialPublicKey' => 'test_initial_public_key',
                        'accountType' => 'EOA'
                    }
                }
            }
        };

        HttpResponse res = new HttpResponse();
        res.setStatusCode(statusCode);
        res.setBody(JSON.serialize(body));

        new CircleHttpCalloutMock().setResponse(req, res).mock();
    }
}
