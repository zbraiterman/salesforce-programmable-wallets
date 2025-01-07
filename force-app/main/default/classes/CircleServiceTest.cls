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
        String message;
        try {
            String result = CircleService.getEntityPublicKey();
        } catch (CircleEndpoint.CircleAPIException excp) {
            message = excp.getMessage();
        }
        Test.stopTest();

        // Verify
        Assert.isNotNull(message);
    }
}
