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
            throw new CircleEndpoint.CircleAPIException(System.Label.ProgrammableWalletsSetup_EntityPublicKey_API_Error);
        }

        EntityPublicKeyResponse result = (EntityPublicKeyResponse) endpoint.deserializeBody(EntityPublicKeyResponse.class);
        return result.data.publicKey;
    }

    public class Data {
        public String publicKey;
    }

    public class EntityPublicKeyResponse {
        public Data data;
    }
}
