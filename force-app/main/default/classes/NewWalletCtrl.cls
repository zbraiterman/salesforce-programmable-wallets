public with sharing class NewWalletCtrl {
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
    public static Id createWallet(WalletData walletData, String entitySecretCipher) {
        try {
            Map<Id, WalletSet__c> walletSetsToId = WalletSetService.getWalletSetToId(new Set<String>{ walletData.walletSetId });
            CircleService.WalletData data = new CircleService.WalletData(entitySecretCipher, walletData, walletSetsToId);
            CircleService.WalletResponse result = CircleService.createWallet(data);

            Wallet__c wallet = new Wallet__c();
            wallet.AccountType__c = result.data.wallets[0].accountType;
            wallet.Address__c = result.data.wallets[0].address;
            wallet.Blockchain__c = result.data.wallets[0].blockchain;
            wallet.CircleId__c = result.data.wallets[0].id;
            wallet.CircleName__c = result.data.wallets[0].name;
            wallet.CircleUserId__c = result.data.wallets[0].userId;
            wallet.CustodyType__c = result.data.wallets[0].custodyType;
            wallet.InitialPublicKey__c = result.data.wallets[0].initialPublicKey;
            wallet.State__c = result.data.wallets[0].state;
            wallet.WalletSet__c = walletData.walletSetId;
            insert as user wallet;

            return wallet.Id;
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

    public class WalletData {
        @AuraEnabled
        public String circleName { get; set; }
        @AuraEnabled
        public String walletSetId { get; set; }
        @AuraEnabled
        public String blockchain { get; set; }
        @AuraEnabled
        public String accountType { get; set; }
    }
}
