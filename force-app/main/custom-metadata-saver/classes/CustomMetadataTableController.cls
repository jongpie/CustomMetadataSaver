//----------------------------------------------------------------------------------------------------//
// This file is part of the Custom Metadata Saver project, released under the MIT License.            //
// See LICENSE file or go to https://github.com/jongpie/CustomMetadataSaver for full license details. //
//----------------------------------------------------------------------------------------------------//

public without sharing class CustomMetadataTableController {
    @AuraEnabled
    public static String getCMDTObjectInfo(String sobjectDeveloperName) {
        return null;
    }

    @AuraEnabled
    public static String deploy(List<SObject> customMetadataRecords) {
        System.debug(
            LoggingLevel.INFO, 
            'CustomMetadataTableController.deploy(customMetadataRecords)==' + customMetadataRecords
        );
        return CustomMetadataSaver.deploy(customMetadataRecords);
    }
}
