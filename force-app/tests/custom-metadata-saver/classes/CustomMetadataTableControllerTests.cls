//----------------------------------------------------------------------------------------------------//
// This file is part of the Custom Metadata Saver project, released under the MIT License.            //
// See LICENSE file or go to https://github.com/jongpie/CustomMetadataSaver for full license details. //
//----------------------------------------------------------------------------------------------------//

@isTest
private class CustomMetadataTableControllerTests {

    @isTest
    static void returnsSObjectApiNameForCmdtRecord() {
        CustomMetadataDeployTest__mdt customMetadataRecord = new CustomMetadataDeployTest__mdt();

        String returnedSObjectApiName = CustomMetadataTableController.getSObjectApiName(customMetadataRecord);
        System.assertEquals(customMetadataRecord.getSObjectType().getDescribe().getName(), returnedSObjectApiName);
    }
}
