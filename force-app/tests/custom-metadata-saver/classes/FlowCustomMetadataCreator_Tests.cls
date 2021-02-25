//----------------------------------------------------------------------------------------------------//
// This file is part of the Custom Metadata Saver project, released under the MIT License.            //
// See LICENSE file or go to https://github.com/jongpie/CustomMetadataSaver for full license details. //
//----------------------------------------------------------------------------------------------------//

@isTest
private inherited sharing class FlowCustomMetadataCreator_Tests {
    @isTest
    static void it_should_initalize_cmdt_record() {
        System.assertEquals(0, CustomMetadataSaver.getAll().size());

        FlowCustomMetadataCreator.FlowInput input = new FlowCustomMetadataCreator.FlowInput();
        input.customMetadataTypeName = SObjectType.CustomMetadataDeployTest__mdt.getName();
        input.masterLabel = 'My new cmdt';
        input.developerName = 'My_new_cmdt';

        List<FlowCustomMetadataCreator.FlowInput> inputs = new List<FlowCustomMetadataCreator.FlowInput>{ input };

        Test.startTest();
        FlowCustomMetadataCreator.initalizeCustomMetadata(inputs);
        Test.stopTest();

        System.assertEquals(1, CustomMetadataSaver.getAll().size());

        CustomMetadataDeployTest__mdt trackedInstance = (CustomMetadataDeployTest__mdt) CustomMetadataSaver.getAll().values().get(0);
        System.assertEquals(input.masterLabel, trackedInstance.MasterLabel);
        System.assertEquals(input.developerName, trackedInstance.DeveloperName);
    }
}
