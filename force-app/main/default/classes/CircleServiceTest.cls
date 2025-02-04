@isTest
private with sharing class CircleServiceTest {
    @IsTest
    static void getEntityPublicKey_Success() {
        // Setup
        TestDataFactory.createSettings();
        TestDataFactory.setEntityPublicKeyMock('new_public_key', 200);

        // Exercise
        Test.startTest();
        String result = CircleService.getEntityPublicKey();
        Test.stopTest();

        // Verify
        Assert.areEqual('new_public_key', result);
    }

    @IsTest
    static void getEntityPublicKey_Error() {
        // Setup
        TestDataFactory.createSettings();
        TestDataFactory.setEntityPublicKeyMock('new_public_key', 400);

        // Exercise
        Test.startTest();
        Boolean isError = false;
        try {
            String result = CircleService.getEntityPublicKey();
        } catch (CircleEndpoint.CircleAPIException excp) {
            isError = true;
        }
        Test.stopTest();

        // Verify
        Assert.isTrue(isError);
    }

    @IsTest
    static void createWalletSet_Success() {
        // Setup
        String name = 'walletSetName';

        TestDataFactory.createSettings();
        TestDataFactory.setCreateWalletSetMock(name, 201);

        // Exercise
        Test.startTest();
        CircleService.WalletSetData data = new CircleService.WalletSetData(name, 'test_entity_secret_cipher');
        CircleService.WalletSetResponse result = CircleService.createWalletSet(data);
        Test.stopTest();

        // Verify
        Assert.areEqual(name, result.data.walletSet.name);
        Assert.isNotNull(result.data.walletSet.custodyType);
        Assert.isNotNull(result.data.walletSet.id);
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
            CircleService.WalletSetData data = new CircleService.WalletSetData(name, 'test_entity_secret_cipher');
            CircleService.createWalletSet(data);
        } catch (CircleEndpoint.CircleAPIException excp) {
            isError = true;
        }
        Test.stopTest();

        // Verify
        Assert.isTrue(isError);
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
        CircleService.WalletData data = new CircleService.WalletData(
            'test_entity_secret_cipher',
            walletData,
            new Map<Id, WalletSet__c>{ walletSet.Id => walletSet }
        );
        CircleService.WalletResponse result = CircleService.createWallet(data);
        Test.stopTest();

        // Verify
        Assert.areEqual(name, result.data.wallets[0].name);
        Assert.isNotNull(result.data.wallets[0].accountType);
        Assert.isNotNull(result.data.wallets[0].address);
        Assert.isNotNull(result.data.wallets[0].blockchain);
        Assert.isNotNull(result.data.wallets[0].custodyType);
        Assert.isNotNull(result.data.wallets[0].id);
        Assert.isNotNull(result.data.wallets[0].initialPublicKey);
        Assert.isNotNull(result.data.wallets[0].state);
        Assert.isNotNull(result.data.wallets[0].userId);
        Assert.isNotNull(result.data.wallets[0].walletSetId);
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
            CircleService.WalletData data = new CircleService.WalletData(
                'test_entity_secret_cipher',
                walletData,
                new Map<Id, WalletSet__c>{ walletSet.Id => walletSet }
            );
            CircleService.WalletResponse result = CircleService.createWallet(data);
        } catch (CircleEndpoint.CircleAPIException excp) {
            isError = true;
        }
        Test.stopTest();

        // Verify
        Assert.isTrue(isError);
    }
}
