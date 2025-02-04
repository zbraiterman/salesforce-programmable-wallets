@isTest
private with sharing class NewWalletCtrlTest {
    @IsTest
    static void getSetup() {
        // Setup
        TestDataFactory.createSettings();

        // Exercise
        Test.startTest();
        NewWalletCtrl.SetupData result = NewWalletCtrl.getSetup();
        Test.stopTest();

        // Verify
        Assert.isNotNull(result.entityPublicKey);
        Assert.isNotNull(result.entitySecret);
    }

    @IsTest
    static void createWallet_Success() {
        // Setup
        String name = 'walletName';

        TestDataFactory.createSettings();
        TestDataFactory.setCreateWalletMock(name, 201);

        WalletSet__c walletSet = TestDataFactory.createWalletSet();
        NewWalletCtrl.WalletData walletData = new NewWalletCtrl.WalletData();
        walletData.circleName = name;
        walletData.walletSetId = walletSet.Id;
        walletData.blockchain = 'EVM';
        walletData.accountType = 'EOA';

        // Exercise
        Test.startTest();
        Id walletId = NewWalletCtrl.createWallet(walletData, 'test_entity_secret_cipher');
        Test.stopTest();

        List<Wallet__c> wallets = [SELECT CircleName__c FROM Wallet__c WHERE Id = :walletId];

        // Verify
        Assert.isNotNull(walletId);
        Assert.areEqual(1, wallets.size());
        Assert.areEqual(name, wallets[0].CircleName__c);
    }

    @IsTest
    static void createWallet_Error() {
        // Setup
        String name = 'walletName';

        TestDataFactory.createSettings();
        TestDataFactory.setCreateWalletMock(name, 400);

        WalletSet__c walletSet = TestDataFactory.createWalletSet();
        NewWalletCtrl.WalletData walletData = new NewWalletCtrl.WalletData();
        walletData.circleName = name;
        walletData.walletSetId = walletSet.Id;
        walletData.blockchain = 'EVM';
        walletData.accountType = 'EOA';

        // Exercise
        Test.startTest();
        Boolean isError = false;
        try {
            NewWalletCtrl.createWallet(walletData, 'test_entity_secret_cipher');
        } catch (AuraHandledException excp) {
            isError = true;
        }
        Test.stopTest();

        List<Wallet__c> wallets = [SELECT Id FROM Wallet__c];

        // Verify
        Assert.areEqual(0, wallets.size());
        Assert.isTrue(isError);
    }
}
