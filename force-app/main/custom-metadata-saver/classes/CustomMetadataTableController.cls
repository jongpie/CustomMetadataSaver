//----------------------------------------------------------------------------------------------------//
// This file is part of the Custom Metadata Saver project, released under the MIT License.            //
// See LICENSE file or go to https://github.com/jongpie/CustomMetadataSaver for full license details. //
//----------------------------------------------------------------------------------------------------//

public without sharing class CustomMetadataTableController {
    @AuraEnabled
    public static List<EntityDefinition> getCustomMetadataTypeEntities() {
        return [
            SELECT Id, Label, QualifiedApiName
            FROM EntityDefinition
            WHERE QualifiedApiName LIKE '%__mdt'
            ORDER BY Label
        ];
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
