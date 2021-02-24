//----------------------------------------------------------------------------------------------------//
// This file is part of the Custom Metadata Saver project, released under the MIT License.            //
// See LICENSE file or go to https://github.com/jongpie/CustomMetadataSaver for full license details. //
//----------------------------------------------------------------------------------------------------//

public inherited sharing class FlowCustomMetadataCreator  {
    public class FlowInput {
        @InvocableVariable(required=true label='The API name of the custom metadata type')
        public String customMetadataTypeName;

        @InvocableVariable(required=true label='The label of the new custom metadata record')
        public String masterLabel;

        @InvocableVariable(required=true label='The unique API name of the new custom metadata record')
        public String developerName;
    }

    @InvocableMethod(category='Custom Metadata' label='Create New Custom Metadata Record' description='Provides the ability to update a field on a custom metadata record')
    public static List<SObject> initalizeCustomMetadata(List<FlowInput> inputs) {
        System.debug('FlowCustomMetadataCreator inputs==' + inputs);

        List<String> customMetadataRecordNames = new List<String>();
        List<SObject> customMetadataRecords = new List<SObject>();

        for(FlowInput input : inputs) {
            SObjectType sobjectType = Schema.getGlobalDescribe().get(input.customMetadataTypeName);
            SObject newCustomMetadataRecord = sobjectType.newSObject();

            newCustomMetadataRecord.put('MasterLabel', input.masterLabel);
            newCustomMetadataRecord.put('DeveloperName', input.developerName);

            String fullName = CustomMetadataSaver.getFullName(newCustomMetadataRecord);
            customMetadataRecordNames.add(fullName);

            CustomMetadataSaver.addInstance(newCustomMetadataRecord);
            customMetadataRecords.add(newCustomMetadataRecord);
        }

        return customMetadataRecords;
    }
}
