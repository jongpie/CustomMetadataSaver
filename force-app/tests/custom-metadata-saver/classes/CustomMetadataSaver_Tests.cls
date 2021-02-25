//----------------------------------------------------------------------------------------------------//
// This file is part of the Custom Metadata Saver project, released under the MIT License.            //
// See LICENSE file or go to https://github.com/jongpie/CustomMetadataSaver for full license details. //
//----------------------------------------------------------------------------------------------------//

@isTest
private class CustomMetadataSaver_Tests {
    private static CustomMetadataDeployTest__mdt getNewRecord() {
        return new CustomMetadataDeployTest__mdt(MasterLabel = 'my test cmdt record', DeveloperName = 'my_test_cmdt_record', ExampleTextField__c = 'hello');
    }

    private static String getFullName(SObject customMetadataRecord) {
        String customMetadataTypePrefix = customMetadataRecord.getSObjectType().getDescribe().getName().replace('__mdt', '');
        return customMetadataTypePrefix + '.' + customMetadataRecord.get('DeveloperName');
    }

    @isTest
    static void it_should_register_new_cmdt_record() {
        System.assertEquals(0, CustomMetadataSaver.getAll().size());

        CustomMetadataDeployTest__mdt cmdtRecord = getNewRecord();

        Test.startTest();
        CustomMetadataSaver.addInstance(cmdtRecord);
        Test.stopTest();

        System.assertEquals(1, CustomMetadataSaver.getAll().size());
        System.assertEquals(cmdtRecord, CustomMetadataSaver.getAll().values().get(0));
    }

    @isTest
    static void it_should_register_new_list_of_cmdt_records() {
        System.assertEquals(0, CustomMetadataSaver.getAll().size());

        List<CustomMetadataDeployTest__mdt> cmdtRecords = new List<CustomMetadataDeployTest__mdt>();
        for (Integer i = 0; i < 10; i++) {
            CustomMetadataDeployTest__mdt cmdtRecord = getNewRecord();
            cmdtRecord.MasterLabel = cmdtRecord.MasterLabel + i;
            cmdtRecord.DeveloperName = cmdtRecord.DeveloperName + i;

            cmdtRecords.add(cmdtRecord);
        }

        Test.startTest();
        CustomMetadataSaver.addAll(cmdtRecords);
        Test.stopTest();

        System.assertEquals(cmdtRecords.size(), CustomMetadataSaver.getAll().size());
        for (CustomMetadataDeployTest__mdt cmdtRecord : cmdtRecords) {
            String fullName = getFullName(cmdtRecord);
            System.assert(CustomMetadataSaver.getAll().containsKey(fullName));
        }
    }

    @isTest
    static void it_should_deploy_cmdt_record() {
        CustomMetadataDeployTest__mdt cmdtRecord = getNewRecord();
        CustomMetadataSaver.addInstance(cmdtRecord);
        cmdtRecord.ExampleCheckboxField__c = true;
        cmdtRecord.ExampleDateField__c = System.today();
        cmdtRecord.ExampleDatetimeField__c = System.now();

        System.assertEquals(1, CustomMetadataSaver.getAll().size());

        Test.startTest();
        CustomMetadataSaver.deploy();
        Test.stopTest();

        System.assertEquals(0, CustomMetadataSaver.getAll().size());
    }
}
