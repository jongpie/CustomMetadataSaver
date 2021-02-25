//----------------------------------------------------------------------------------------------------//
// This file is part of the Custom Metadata Saver project, released under the MIT License.            //
// See LICENSE file or go to https://github.com/jongpie/CustomMetadataSaver for full license details. //
//----------------------------------------------------------------------------------------------------//

@isTest
private class CustomMetadataSaver_Tests {
    @isTest
    static void it_should_deploy_cmdt_record() {
        CustomMetadataDeployTest__mdt cmdtRecord = getNewRecord();
        cmdtRecord.ExampleCheckboxField__c = true;
        cmdtRecord.ExampleDateField__c = System.today();
        cmdtRecord.ExampleDatetimeField__c = System.now();

        List<CustomMetadataDeployTest__mdt> cdmtRecords = new List<CustomMetadataDeployTest__mdt>{ cmdtRecord };

        System.assertEquals(1, cdmtRecords.size());

        Test.startTest();
        CustomMetadataSaver.deploy(cdmtRecords);
        Test.stopTest();

        System.assertEquals(1, CustomMetadataSaver.getDeploymentJobIds().size());
    }
}
