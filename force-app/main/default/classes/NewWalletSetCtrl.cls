public with sharing class NewWalletSetCtrl {
    @AuraEnabled
    public static SetupData getSetup() {
        try {
            return new SetupData()
                .withEntityPublicKey(ProgrammableWalletsService.getEntityPublicKey())
                .withEntitySecret(ProgrammableWalletsService.getEntitySecret());
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Id createWalletSet(String walletSetName, String entitySecretCipher) {
        try {
            CircleService.WalletSetData data = new CircleService.WalletSetData(walletSetName, entitySecretCipher);
            CircleService.WalletSetResponse result = CircleService.createWalletSet(data);

            WalletSet__c walletSet = new WalletSet__c();
            walletSet.CircleId__c = result.data.walletSet.id;
            walletSet.CircleName__c = result.data.walletSet.name;
            walletSet.CustodyType__c = result.data.walletSet.custodyType;
            insert as user walletSet;

            return walletSet.Id;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class SetupData {
        @AuraEnabled
        public String entityPublicKey { get; set; }
        @AuraEnabled
        public String entitySecret { get; set; }

        public SetupData withEntityPublicKey(String value) {
            entityPublicKey = enrich(value);
            return this;
        }

        public SetupData withEntitySecret(String value) {
            entitySecret = enrich(value);
            return this;
        }

        private String enrich(String value) {
            return value == null ? '' : value;
        }
    }
}
