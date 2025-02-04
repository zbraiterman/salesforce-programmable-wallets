@isTest
private with sharing class ProgrammableWalletsSetupCtrlTest {
    @IsTest
    static void getSetup() {
        // Setup
        TestDataFactory.createSettings();

        // Exercise
        Test.startTest();
        ProgrammableWalletsSetupCtrl.SetupData result = ProgrammableWalletsSetupCtrl.getSetup();
        Test.stopTest();

        // Verify
        Assert.isNotNull(result.apiKey);
        Assert.isTrue(result.consoleRegistered);
        Assert.isNotNull(result.entityPublicKey);
        Assert.isNotNull(result.entitySecret);
        Assert.isNotNull(result.entitySecretCiphertext);
    }

    @IsTest
    static void removeConfig() {
        // Setup
        TestDataFactory.createSettings();

        // Exercise
        Test.startTest();
        ProgrammableWalletsSetupCtrl.SetupData result = ProgrammableWalletsSetupCtrl.removeConfig();
        Test.stopTest();

        // Verify
        Assert.areEqual('', result.apiKey);
        Assert.isFalse(result.consoleRegistered);
        Assert.areEqual('', result.entityPublicKey);
        Assert.areEqual('', result.entitySecret);
        Assert.areEqual('', result.entitySecretCiphertext);
    }

    @IsTest
    static void saveSettings() {
        // Setup
        TestDataFactory.createSettings();

        ProgrammableWalletsSetupCtrl.SetupData data = new ProgrammableWalletsSetupCtrl.SetupData();
        data.apiKey = 'new_api_key';
        data.entitySecretCiphertext = 'new_entity_secret_ciphertext';

        // Exercise
        Test.startTest();
        ProgrammableWalletsSetupCtrl.SetupData result = ProgrammableWalletsSetupCtrl.saveSettings(data);
        Test.stopTest();

        // Verify
        Assert.areEqual('new_api_key', result.apiKey);
        Assert.areEqual('new_entity_secret_ciphertext', result.entitySecretCiphertext);
    }

    @IsTest
    static void generateEnitySecret() {
        // Setup
        // No initial settings setup

        // Exercise
        Test.startTest();
        ProgrammableWalletsSetupCtrl.SetupData result = ProgrammableWalletsSetupCtrl.generateEnitySecret();
        Test.stopTest();

        // Verify
        Assert.isNotNull(result.entitySecret);
    }

    @IsTest
    static void generateEnityPublicKey() {
        // Setup
        TestDataFactory.createSettings();
        TestDataFactory.setEntityPublicKeyMock('new_public_key', 200);

        // Exercise
        Test.startTest();
        ProgrammableWalletsSetupCtrl.SetupData result = ProgrammableWalletsSetupCtrl.generateEnityPublicKey();
        Test.stopTest();

        // Verify
        Assert.areEqual('new_public_key', result.entityPublicKey);
    }

    @IsTest
    static void generateEnityPublicKey_Error() {
        // Setup
        TestDataFactory.createSettings();
        TestDataFactory.setEntityPublicKeyMock('new_public_key', 400);

        // Exercise
        Test.startTest();
        Boolean isError = false;
        try {
            ProgrammableWalletsSetupCtrl.generateEnityPublicKey();
        } catch (AuraHandledException excp) {
            isError = true;
        }
        Test.stopTest();

        // Verify
        Assert.isTrue(isError);
    }

    @IsTest
    static void completeConsoleRegistered() {
        // Setup
        // No initial settings setup

        // Exercise
        Test.startTest();
        ProgrammableWalletsSetupCtrl.SetupData result = ProgrammableWalletsSetupCtrl.completeConsoleRegistered();
        Test.stopTest();

        // Verify
        Assert.isTrue(result.consoleRegistered);
    }
}
