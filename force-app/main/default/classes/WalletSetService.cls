public with sharing class WalletSetService {
    public static Map<Id, WalletSet__c> getWalletSetToId(Set<String> walletSetIds) {
        return new Map<Id, WalletSet__c>([SELECT CircleId__c FROM WalletSet__c WHERE Id IN :walletSetIds]);
    }
}
