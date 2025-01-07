public with sharing class ProgrammableWalletsSetupCtrl {
    @AuraEnabled
    public static SetupData getSetup() {
        try {
            return new SetupData()
                .withApiKey(ProgrammableWalletsService.getAPIKey())
                .withConsoleRegistered(ProgrammableWalletsService.getConsoleRegistered())
                .withEntityPublicKey(ProgrammableWalletsService.getEntityPublicKey())
                .withEntitySecret(ProgrammableWalletsService.getEntitySecret())
                .withEntitySecretCiphertext(ProgrammableWalletsService.getEntitySecretCiphertext());
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static SetupData removeConfig() {
        try {
            ProgrammableWalletsService.removeSettings();
            return getSetup();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static SetupData saveSettings(SetupData data) {
        try {
            if (data.apiKey != null) {
                ProgrammableWalletsService.setApiKey(data.apiKey);
            }
            if (data.entitySecretCiphertext != null) {
                ProgrammableWalletsService.setEntitySecretCiphertext(data.entitySecretCiphertext);
            }
            ProgrammableWalletsService.saveSettings();
            return getSetup();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static SetupData generateEnitySecret() {
        try {
            ProgrammableWalletsService.setEntitySecret(EncodingUtil.convertToHex(Crypto.generateAesKey(256)));
            ProgrammableWalletsService.saveSettings();
            return getSetup();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static SetupData generateEnityPublicKey() {
        try {
            ProgrammableWalletsService.setEntityPublicKey(CircleService.getEntityPublicKey());
            ProgrammableWalletsService.saveSettings();
            return getSetup();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static SetupData completeConsoleRegistered() {
        try {
            ProgrammableWalletsService.setConsoleRegistered(true);
            ProgrammableWalletsService.saveSettings();
            return getSetup();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class SetupData {
        @AuraEnabled
        public String apiKey { get; set; }
        @AuraEnabled
        public Boolean consoleRegistered { get; set; }
        @AuraEnabled
        public String entityPublicKey { get; set; }
        @AuraEnabled
        public String entitySecret { get; set; }
        @AuraEnabled
        public String entitySecretCiphertext { get; set; }

        public SetupData withApiKey(String value) {
            apiKey = enrich(value);
            return this;
        }

        public SetupData withConsoleRegistered(Boolean value) {
            consoleRegistered = value;
            return this;
        }

        public SetupData withEntityPublicKey(String value) {
            entityPublicKey = enrich(value);
            return this;
        }

        public SetupData withEntitySecret(String value) {
            entitySecret = enrich(value);
            return this;
        }

        public SetupData withEntitySecretCiphertext(String value) {
            entitySecretCiphertext = enrich(value);
            return this;
        }

        private String enrich(String value) {
            return value == null ? '' : value;
        }
    }
}
