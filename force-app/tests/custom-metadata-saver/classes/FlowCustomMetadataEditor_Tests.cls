//----------------------------------------------------------------------------------------------------//
// This file is part of the Custom Metadata Saver project, released under the MIT License.            //
// See LICENSE file or go to https://github.com/jongpie/CustomMetadataSaver for full license details. //
//----------------------------------------------------------------------------------------------------//

@isTest
private class FlowCustomMetadataEditor_Tests {
    private static CustomMetadataDeployTest__mdt getNewRecord() {
        return new CustomMetadataDeployTest__mdt(MasterLabel = 'my test cmdt record', DeveloperName = 'my_test_cmdt_record', ExampleTextField__c = 'hello');
    }

    private static String getFullName(SObject customMetadataRecord) {
        String customMetadataTypePrefix = customMetadataRecord.getSObjectType().getDescribe().getName().replace('__mdt', '');
        return customMetadataTypePrefix + '.' + customMetadataRecord.get('DeveloperName');
    }

    @isTest
    static void it_should_set_cmdt_record_checkbox_field() {
        System.assertEquals(0, CustomMetadataSaver.getAll().size());

        CustomMetadataDeployTest__mdt cmdtRecord = getNewRecord();
        CustomMetadataSaver.addInstance(cmdtRecord);

        System.assertEquals(1, CustomMetadataSaver.getAll().size());

        FlowCustomMetadataEditor.FlowInput input = new FlowCustomMetadataEditor.FlowInput();
        input.customMetadataRecord = cmdtRecord;
        input.fieldName = CustomMetadataDeployTest__mdt.ExampleCheckboxField__c.getDescribe().getName();
        input.fieldValue = 'true';

        List<FlowCustomMetadataEditor.FlowInput> inputs = new List<FlowCustomMetadataEditor.FlowInput>{ input };

        Test.startTest();

        FlowCustomMetadataEditor.setCustomMetadataField(inputs);

        Test.stopTest();

        System.assertEquals(1, CustomMetadataSaver.getAll().size());

        CustomMetadataDeployTest__mdt trackedInstance = (CustomMetadataDeployTest__mdt) CustomMetadataSaver.getAll().values().get(0);
        System.assertEquals(cmdtRecord.MasterLabel, trackedInstance.MasterLabel);
        System.assertEquals(trackedInstance.get(input.fieldName), Boolean.valueOf(input.fieldValue));
        System.assertEquals(cmdtRecord.developerName, trackedInstance.DeveloperName);
    }

    // FIXME get unit test to parse date
    // @isTest
    // static void it_should_set_cmdt_record_date_field() {
    //     System.assertEquals(0, CustomMetadataSaver.getAll().size());

    //     CustomMetadataDeployTest__mdt cmdtRecord = getNewRecord();
    //     CustomMetadataSaver.addInstance(cmdtRecord);

    //     System.assertEquals(1, CustomMetadataSaver.getAll().size());

    //     FlowCustomMetadataEditor.FlowInput input = new FlowCustomMetadataEditor.FlowInput();
    //     input.customMetadataRecord = cmdtRecord;
    //     input.fieldName = CustomMetadataDeployTest__mdt.ExampleDateField__c.getDescribe().getName();
    //     input.fieldValue = '2020-12-13';

    //     List<FlowCustomMetadataEditor.FlowInput> inputs = new List<FlowCustomMetadataEditor.FlowInput>{ input };

    //     Test.startTest();

    //     FlowCustomMetadataEditor.setCustomMetadataField(inputs);

    //     Test.stopTest();

    //     System.assertEquals(1, CustomMetadataSaver.getAll().size());

    //     CustomMetadataDeployTest__mdt trackedInstance = (CustomMetadataDeployTest__mdt) CustomMetadataSaver.getAll().values().get(0);
    //     System.assertEquals(cmdtRecord.MasterLabel, trackedInstance.MasterLabel);
    //     System.assertEquals(trackedInstance.get(input.fieldName), Date.valueOf(input.fieldValue));
    //     System.assertEquals(cmdtRecord.developerName, trackedInstance.DeveloperName);
    // }

    // FIXME get unit test to parse datetime
    // @isTest
    // static void it_should_set_cmdt_record_datetime_field() {
    //     System.assertEquals(0, CustomMetadataSaver.getAll().size());

    //     CustomMetadataDeployTest__mdt cmdtRecord = getNewRecord();
    //     CustomMetadataSaver.addInstance(cmdtRecord);

    //     System.assertEquals(1, CustomMetadataSaver.getAll().size());

    //     FlowCustomMetadataEditor.FlowInput input = new FlowCustomMetadataEditor.FlowInput();
    //     input.customMetadataRecord = cmdtRecord;
    //     input.fieldName = CustomMetadataDeployTest__mdt.ExampleDatetimeField__c.getDescribe().getName();
    //     input.fieldValue = 'Tue Jan 03 00:00:00 GMT 2';

    //     List<FlowCustomMetadataEditor.FlowInput> inputs = new List<FlowCustomMetadataEditor.FlowInput>{ input };

    //     Test.startTest();

    //     FlowCustomMetadataEditor.setCustomMetadataField(inputs);

    //     Test.stopTest();

    //     System.assertEquals(1, CustomMetadataSaver.getAll().size());

    //     CustomMetadataDeployTest__mdt trackedInstance = (CustomMetadataDeployTest__mdt) CustomMetadataSaver.getAll().values().get(0);
    //     System.assertEquals(cmdtRecord.MasterLabel, trackedInstance.MasterLabel);
    //     System.assertEquals(cmdtRecord.DeveloperName, trackedInstance.DeveloperName);
    //     System.assertEquals( (Datetime)JSON.deserialize(input.fieldValue, Datetime.class), trackedInstance.get(input.fieldName));
    // }

    @isTest
    static void it_should_set_cmdt_record_number_field() {
        System.assertEquals(0, CustomMetadataSaver.getAll().size());

        CustomMetadataDeployTest__mdt cmdtRecord = getNewRecord();
        CustomMetadataSaver.addInstance(cmdtRecord);

        System.assertEquals(1, CustomMetadataSaver.getAll().size());

        FlowCustomMetadataEditor.FlowInput input = new FlowCustomMetadataEditor.FlowInput();
        input.customMetadataRecord = cmdtRecord;
        input.fieldName = CustomMetadataDeployTest__mdt.ExampleNumberField__c.getDescribe().getName();
        input.fieldValue = String.valueOf(123.987);

        List<FlowCustomMetadataEditor.FlowInput> inputs = new List<FlowCustomMetadataEditor.FlowInput>{ input };

        Test.startTest();

        FlowCustomMetadataEditor.setCustomMetadataField(inputs);

        Test.stopTest();

        System.assertEquals(1, CustomMetadataSaver.getAll().size());

        CustomMetadataDeployTest__mdt trackedInstance = (CustomMetadataDeployTest__mdt) CustomMetadataSaver.getAll().values().get(0);
        System.assertEquals(cmdtRecord.MasterLabel, trackedInstance.MasterLabel);
        System.assertEquals(trackedInstance.get(input.fieldName), Decimal.valueOf(input.fieldValue));
        System.assertEquals(cmdtRecord.developerName, trackedInstance.DeveloperName);
    }

    @isTest
    static void it_should_set_cmdt_record_text_field() {
        System.assertEquals(0, CustomMetadataSaver.getAll().size());

        CustomMetadataDeployTest__mdt cmdtRecord = getNewRecord();
        CustomMetadataSaver.addInstance(cmdtRecord);

        System.assertEquals(1, CustomMetadataSaver.getAll().size());

        FlowCustomMetadataEditor.FlowInput input = new FlowCustomMetadataEditor.FlowInput();
        input.customMetadataRecord = cmdtRecord;
        input.fieldName = CustomMetadataDeployTest__mdt.ExampleTextField__c.getDescribe().getName();
        input.fieldValue = 'hello, world!';

        List<FlowCustomMetadataEditor.FlowInput> inputs = new List<FlowCustomMetadataEditor.FlowInput>{ input };

        Test.startTest();

        FlowCustomMetadataEditor.setCustomMetadataField(inputs);

        Test.stopTest();

        System.assertEquals(1, CustomMetadataSaver.getAll().size());

        CustomMetadataDeployTest__mdt trackedInstance = (CustomMetadataDeployTest__mdt) CustomMetadataSaver.getAll().values().get(0);
        System.assertEquals(cmdtRecord.MasterLabel, trackedInstance.MasterLabel);
        System.assertEquals(trackedInstance.get(input.fieldName), input.fieldValue);
        System.assertEquals(cmdtRecord.developerName, trackedInstance.DeveloperName);
    }
}
