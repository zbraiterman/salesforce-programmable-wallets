@isTest
private with sharing class ProgrammableWalletsServiceTest {
    @IsTest
    static void getSettings() {
        // Setup
        TestDataFactory.createSettings();

        // Exercise

        // Verify
        Assert.isNotNull(ProgrammableWalletsService.getAPIKey());
        Assert.isTrue(ProgrammableWalletsService.getConsoleRegistered());
        Assert.isNotNull(ProgrammableWalletsService.getEntityPublicKey());
        Assert.isNotNull(ProgrammableWalletsService.getEntitySecret());
        Assert.isNotNull(ProgrammableWalletsService.getEntitySecretCiphertext());
    }

    @IsTest
    static void saveSettings() {
        // Setup
        ProgrammableWalletsService.setting = null;

        // Exercise
        Test.startTest();
        ProgrammableWalletsService.setAPIKey('new_api_key');
        ProgrammableWalletsService.setConsoleRegistered(true);
        ProgrammableWalletsService.setEntityPublicKey('new_entity_public_key');
        ProgrammableWalletsService.setEntitySecret('new_entity_secret');
        ProgrammableWalletsService.setEntitySecretCiphertext('new_entity_secret_ciphertext');
        ProgrammableWalletsService.saveSettings();
        Test.stopTest();

        // Verify
        Assert.isNotNull(ProgrammableWalletsService.getAPIKey());
        Assert.isTrue(ProgrammableWalletsService.getConsoleRegistered());
        Assert.isNotNull(ProgrammableWalletsService.getEntityPublicKey());
        Assert.isNotNull(ProgrammableWalletsService.getEntitySecret());
        Assert.isNotNull(ProgrammableWalletsService.getEntitySecretCiphertext());
    }

    @IsTest
    static void deleteSettings() {
        // Setup
        TestDataFactory.createSettings();

        // Exercise
        Test.startTest();
        ProgrammableWalletsService.removeSettings();
        Test.stopTest();

        // Verify
        Assert.isNull(ProgrammableWalletsService.getAPIKey());
        Assert.isFalse(ProgrammableWalletsService.getConsoleRegistered());
        Assert.isNull(ProgrammableWalletsService.getEntityPublicKey());
        Assert.isNull(ProgrammableWalletsService.getEntitySecret());
        Assert.isNull(ProgrammableWalletsService.getEntitySecretCiphertext());
    }
}
