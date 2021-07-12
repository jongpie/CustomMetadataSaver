//----------------------------------------------------------------------------------------------------//
// This file is part of the Custom Metadata Saver project, released under the MIT License.            //
// See LICENSE file or go to https://github.com/jongpie/CustomMetadataSaver for full license details. //
//----------------------------------------------------------------------------------------------------//

public without sharing class CustomMetadataTableController {
    private static String BASE_URL = System.Url.getOrgDomainUrl().toExternalForm() + '/services/data/v49.0';

    @AuraEnabled
    public static String getSObjectApiName(SObject customMetadataRecord) {
        System.debug(LoggingLevel.INFO, 'CustomMetadataTableController.getSObjectApiName(customMetadataRecord)==' + customMetadataRecord);
        return customMetadataRecord.getSObjectType().getDescribe().getName();
    }

    @AuraEnabled
    public static String deploy(List<SObject> customMetadataRecords) {
        System.debug(LoggingLevel.INFO, 'CustomMetadataTableController.deploy(customMetadataRecords)==' + customMetadataRecords);
        return CustomMetadataSaver.deploy(customMetadataRecords);
    }

    @AuraEnabled
    public static DeploymentStatusResponse getDeploymentStatus(Id deploymentJobId) {
        System.debug(LoggingLevel.INFO, 'deploymentJobId==' + deploymentJobId);

        final String deploymentStatusUrl = BASE_URL + '/metadata/deployRequest/' + deploymentJobId + '?includeDetails=true';

        HttpRequest request = new HttpRequest();
        request.setEndpoint(deploymentStatusUrl);
        request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        request.setHeader('Content-Type', 'application/json; charset=utf-8');
        request.setMethod('GET');

        HttpResponse response = new Http().send(request);
        DeploymentStatusResponse deploymentStatusResponse = (DeploymentStatusResponse) JSON.deserialize(response.getBody(), DeploymentStatusResponse.class);
        System.debug(LoggingLevel.INFO, 'deploymentStatusResponse==' + deploymentStatusResponse);
        return deploymentStatusResponse;
    }

    // DTOs based on the REST API's response for deployments
    // https://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/meta_rest_deploy_checkstatus.htm
    public class DeploymentStatusResponse {
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String url;
        @AuraEnabled
        public DeployResult deployResult;
    }

    private class DeployResult {
        @AuraEnabled
        public String status;
        @AuraEnabled
        public Integer numberComponentsDeployed;
        @AuraEnabled
        public Integer numberComponentsTotal;
        @AuraEnabled
        public Integer numberComponentErrors;
    }
}
