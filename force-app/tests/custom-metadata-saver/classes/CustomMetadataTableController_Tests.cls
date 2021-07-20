//----------------------------------------------------------------------------------------------------//
// This file is part of the Custom Metadata Saver project, released under the MIT License.            //
// See LICENSE file or go to https://github.com/jongpie/CustomMetadataSaver for full license details. //
//----------------------------------------------------------------------------------------------------//

@isTest
private class CustomMetadataTableController_Tests {
    private class DeploymentCalloutMock implements HttpCalloutMock {
        private String deploymentId;
        private String status;
        private Integer statusCode;

        public DeploymentCalloutMock setDeploymentId(String deploymentId) {
            this.deploymentId = deploymentId;
            return this;
        }

        public DeploymentCalloutMock setStatus(String status, Integer statusCode) {
            this.status = status;
            this.statusCode = statusCode;
            return this;
        }

        public HTTPResponse respond(HTTPRequest req) {
            CustomMetadataTableController.DeployResult deployResult = new CustomMetadataTableController.DeployResult();
            deployResult.status = this.status;

            CustomMetadataTableController.DeploymentStatusResponse deploymentStatusResponse = new CustomMetadataTableController.DeploymentStatusResponse();
            deploymentStatusResponse.deployResult = deployResult;
            deploymentStatusResponse.id = this.deploymentId;

            HttpResponse httpResponse = new HttpResponse();
            httpResponse.setHeader('Content-Type', 'application/json');
            httpResponse.setBody(JSON.serialize(deploymentStatusResponse));
            httpResponse.setStatusCode(this.statusCode);
            return httpResponse;
        }
    }

    @isTest
    static void it_should_return_sobject_api_name_for_custom_metadata_record() {
        CustomMetadataDeployTest__mdt customMetadataRecord = new CustomMetadataDeployTest__mdt();

        String returnedSObjectApiName = CustomMetadataTableController.getSObjectApiName(customMetadataRecord);
        System.assertEquals(customMetadataRecord.getSObjectType().getDescribe().getName(), returnedSObjectApiName);
    }

    @isTest
    static void it_should_get_deployment_status_when_deployment_succeeds() {
        String fakeId = 'someDeploymentId';
        String status = 'Succeeded';
        Integer statusCode = 200;

        DeploymentCalloutMock mock = new DeploymentCalloutMock().setDeploymentId(fakeId).setStatus(status, statusCode);
        Test.setMock(HttpCalloutMock.class, mock);

        CustomMetadataTableController.DeploymentStatusResponse deploymentStatusResponse = CustomMetadataTableController.getDeploymentStatus(fakeId);
        System.assertEquals(fakeId, deploymentStatusResponse.id);
        System.assertEquals(status, deploymentStatusResponse.deployResult.status);
    }
}
