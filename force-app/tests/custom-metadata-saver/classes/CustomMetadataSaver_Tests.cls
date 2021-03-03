//----------------------------------------------------------------------------------------------------//
// This file is part of the Custom Metadata Saver project, released under the MIT License.            //
// See LICENSE file or go to https://github.com/jongpie/CustomMetadataSaver for full license details. //
//----------------------------------------------------------------------------------------------------//

@isTest
private class CustomMetadataSaver_Tests {
    @isTest
    static void it_should_deploy_cmdt_record_for_list_of_cmdt() {
        CustomMetadataDeployTest__mdt cmdtRecord = new CustomMetadataDeployTest__mdt(
            MasterLabel = 'my test cmdt record',
            DeveloperName = 'my_test_cmdt_record',
            ExampleCheckboxField__c = true,
            ExampleDateField__c = System.today(),
            ExampleDatetimeField__c = System.now(),
            ExampleTextField__c = 'hello'
        );

        List<CustomMetadataDeployTest__mdt> cdmtRecords = new List<CustomMetadataDeployTest__mdt>{ cmdtRecord };

        System.assertEquals(1, cdmtRecords.size());

        Test.startTest();
        CustomMetadataSaver.deploy(cdmtRecords);
        Test.stopTest();

        System.assertEquals(1, CustomMetadataSaver.getDeploymentJobIds().size());
    }

    @isTest
    static void it_should_deploy_cmdt_record_for_list_of_flowInputs() {
        CustomMetadataDeployTest__mdt cmdtRecord = new CustomMetadataDeployTest__mdt(
            MasterLabel = 'my test cmdt record',
            DeveloperName = 'my_test_cmdt_record',
            ExampleCheckboxField__c = true,
            ExampleDateField__c = System.today(),
            ExampleDatetimeField__c = System.now(),
            ExampleTextField__c = 'hello'
        );

        List<CustomMetadataDeployTest__mdt> cdmtRecords = new List<CustomMetadataDeployTest__mdt>{ cmdtRecord };
        CustomMetadataSaver.FlowInput input = new CustomMetadataSaver.FlowInput();
        input.customMetadataRecords = cdmtRecords;

        List<CustomMetadataSaver.FlowInput> inputs = new List<CustomMetadataSaver.FlowInput>();
        inputs.add(input);

        System.assertEquals(1, cdmtRecords.size());

        Test.startTest();
        CustomMetadataSaver.deploy(cdmtRecords);
        Test.stopTest();

        System.assertEquals(1, CustomMetadataSaver.getDeploymentJobIds().size());
    }
}
