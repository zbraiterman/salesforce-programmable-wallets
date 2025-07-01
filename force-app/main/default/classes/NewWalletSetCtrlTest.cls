@isTest
private with sharing class NewWalletSetCtrlTest {
    @IsTest
    static void getSetup() {
        // Setup
        TestDataFactory.createSettings();

        // Exercise
        Test.startTest();
        NewWalletSetCtrl.SetupData result = NewWalletSetCtrl.getSetup();
        Test.stopTest();

        // Verify
        Assert.isNotNull(result.entityPublicKey);
        Assert.isNotNull(result.entitySecret);
    }

    @IsTest
    static void createWalletSet_Success() {
        // Setup
        String name = 'walletSetName';

        TestDataFactory.createSettings();
        TestDataFactory.setCreateWalletSetMock(name, 201);

        // Exercise
        Test.startTest();
        Id walletSetId = NewWalletSetCtrl.createWalletSet(name, 'test_entity_secret_cipher');
        Test.stopTest();

        List<WalletSet__c> walletSets = [SELECT CircleName__c FROM WalletSet__c WHERE Id = :walletSetId];

        // Verify
        Assert.isNotNull(walletSetId);
        Assert.areEqual(1, walletSets.size());
        Assert.areEqual(name, walletSets[0].CircleName__c);
    }

    @IsTest
    static void createWalletSet_Error() {
        // Setup
        String name = 'walletSetName';

        TestDataFactory.createSettings();
        TestDataFactory.setCreateWalletSetMock(name, 400);

        // Exercise
        Test.startTest();
        Boolean isError = false;
        try {
            NewWalletSetCtrl.createWalletSet(name, 'test_entity_secret_cipher');
        } catch (AuraHandledException excp) {
            isError = true;
        }
        Test.stopTest();

        List<WalletSet__c> walletSets = [SELECT Id FROM WalletSet__c];

        // Verify
        Assert.areEqual(0, walletSets.size());
        Assert.isTrue(isError);
    }
}
