public with sharing class ProgrammableWalletsService {
    public static final String IDENTIFIER = 'Production';

    @TestVisible
    private static ProgrammableWalletsSetting__c setting {
        get {
            if (setting == null) {
                List<ProgrammableWalletsSetting__c> settings = [
                    SELECT ApiKey__c, ConsoleRegistered__c, EntityPublicKey__c, EntitySecret__c, EntitySecretCiphertext__c, Identifier__c
                    FROM ProgrammableWalletsSetting__c
                    WHERE Identifier__c = :IDENTIFIER
                ];

                if (settings.isEmpty()) {
                    ProgrammableWalletsSetting__c initialSetting = new ProgrammableWalletsSetting__c();
                    initialSetting.Identifier__c = IDENTIFIER;
                    insert initialSetting;

                    setting = initialSetting;
                } else {
                    setting = settings[0];
                }
            }
            return setting;
        }
        set;
    }

    public static String getApiKey() {
        return setting.ApiKey__c;
    }

    public static Boolean getConsoleRegistered() {
        return setting.ConsoleRegistered__c;
    }

    public static String getEntitySecret() {
        return setting.EntitySecret__c;
    }

    public static String getEntityPublicKey() {
        return setting.EntityPublicKey__c;
    }

    public static String getEntitySecretCiphertext() {
        return setting.EntitySecretCiphertext__c;
    }

    public static void setApiKey(String value) {
        setting.ApiKey__c = value;
    }

    public static void setConsoleRegistered(Boolean value) {
        setting.ConsoleRegistered__c = value;
    }

    public static void setEntityPublicKey(String value) {
        setting.EntityPublicKey__c = value;
    }

    public static void setEntitySecret(String value) {
        setting.EntitySecret__c = value;
    }

    public static void setEntitySecretCiphertext(String value) {
        setting.EntitySecretCiphertext__c = value;
    }

    public static void saveSettings() {
        SObjectAccessDecision decision = Security.stripInaccessible(AccessType.UPSERTABLE, new List<ProgrammableWalletsSetting__c>{ setting });
        List<ProgrammableWalletsSetting__c> prepSettings = (List<ProgrammableWalletsSetting__c>) decision.getRecords();

        upsert as user prepSettings;
    }

    public static void removeSettings() {
        delete as user setting;
        setting = null;
    }
}
