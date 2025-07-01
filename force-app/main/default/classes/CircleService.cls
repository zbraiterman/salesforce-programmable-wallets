public with sharing class CircleService {
    public static String getEntityPublicKey() {
        CircleEndpoint endpoint = new CircleEndpoint()
            .get()
            .setEndpoint('/config/entity/publicKey')
            .setHeaders(
                new Map<String, String>{ 'Content-Type' => 'application/json', 'Authorization' => 'Bearer ' + ProgrammableWalletsService.getApiKey() }
            )
            .send();

        if (endpoint.getStatusCode() != 200) {
            throw new CircleEndpoint.CircleAPIException(
                System.Label.ProgrammableWalletsSetup_EntityPublicKey_API_Error + getErrorMessage(endpoint.getResponse().getBody())
            );
        }

        EntityPublicKeyResponse result = (EntityPublicKeyResponse) endpoint.deserializeBody(EntityPublicKeyResponse.class);
        return result.data.publicKey;
    }

    public static WalletSetResponse createWalletSet(WalletSetData data) {
        CircleEndpoint endpoint = new CircleEndpoint()
            .post()
            .setEndpoint('/developer/walletSets')
            .setHeaders(
                new Map<String, String>{
                    'Accept' => 'application/json',
                    'Content-Type' => 'application/json',
                    'Authorization' => 'Bearer ' + ProgrammableWalletsService.getApiKey()
                }
            )
            .setBody(JSON.serialize(data))
            .send();

        if (!(new List<Integer>{ 200, 201 }).contains(endpoint.getStatusCode())) {
            throw new CircleEndpoint.CircleAPIException(
                System.Label.CircleService_CreateWalletSet_API_Error + getErrorMessage(endpoint.getResponse().getBody())
            );
        }

        WalletSetResponse result = (WalletSetResponse) endpoint.deserializeBody(WalletSetResponse.class);
        return result;
    }

    public static WalletResponse createWallet(WalletData data) {
        CircleEndpoint endpoint = new CircleEndpoint()
            .post()
            .setEndpoint('/developer/wallets')
            .setHeaders(
                new Map<String, String>{
                    'Accept' => 'application/json',
                    'Content-Type' => 'application/json',
                    'Authorization' => 'Bearer ' + ProgrammableWalletsService.getApiKey()
                }
            )
            .setBody(JSON.serialize(data))
            .send();

        if (!(new List<Integer>{ 200, 201 }).contains(endpoint.getStatusCode())) {
            throw new CircleEndpoint.CircleAPIException(
                System.Label.CircleService_CreateWallet_API_Error + getErrorMessage(endpoint.getResponse().getBody())
            );
        }

        WalletResponse result = (WalletResponse) endpoint.deserializeBody(WalletResponse.class);
        return result;
    }

    public static String getErrorMessage(String errorMessage) {
        CirlcePlatformError errors = (CirlcePlatformError) JSON.deserialize(errorMessage, CirlcePlatformError.class);
        return ' ' + errors.message;
    }

    public class EntityPublicKeyResponse {
        public EPKData data;
    }

    public class EPKData {
        public String publicKey;
    }

    public class WalletSetData {
        public String idempotencyKey;
        public String entitySecretCiphertext;
        public String name;

        public WalletSetData(String walletSetName, String entitySecretCipher) {
            idempotencyKey = UUID.randomUUID().toString();
            entitySecretCiphertext = entitySecretCipher;

            name = walletSetName;
        }
    }

    public class WalletSetResponse {
        public WSData data;
    }

    public class WSData {
        public WSDataWalletSet walletSet;
    }

    public class WSDataWalletSet {
        public String id;
        public String custodyType;
        public String name;
    }

    public class WalletData {
        public String idempotencyKey;
        public String entitySecretCiphertext;

        public List<String> blockchains;
        public String walletSetId;
        public String accountType;
        public Integer count;
        public List<WalletDataMetadata> metadata;

        public WalletData(String entitySecretCipher, NewWalletCtrl.WalletData data, Map<Id, WalletSet__c> walletSetsToId) {
            idempotencyKey = UUID.randomUUID().toString();
            entitySecretCiphertext = entitySecretCipher;

            blockchains = new List<String>{ data.blockchain };
            walletSetId = walletSetsToId.get(data.walletSetId)?.CircleId__c;
            accountType = data.accountType;
            count = 1;
            metadata = new List<WalletDataMetadata>{ new WalletDataMetadata(data.circleName) };
        }
    }

    public class WalletDataMetadata {
        public String name;

        public WalletDataMetadata(String walletName) {
            name = walletName;
        }
    }

    public class WalletResponse {
        public WData data;
    }

    public class WData {
        public List<WDataWallets> wallets;
    }

    public class WDataWallets {
        public String id;
        public String address;
        public String blockchain;
        public String custodyType;
        public String name;
        public String state;
        public String userId;
        public String walletSetId;
        public String initialPublicKey;
        public String accountType;
    }

    public class CirlcePlatformError {
        public Integer code;
        public String message;
    }
}
