//----------------------------------------------------------------------------------------------------//
// This file is part of the Custom Metadata Saver project, released under the MIT License.            //
// See LICENSE file or go to https://github.com/jongpie/CustomMetadataSaver for full license details. //
//----------------------------------------------------------------------------------------------------//

public inherited sharing class CustomMetadataSaver {
    private static final Set<String> IGNORED_FIELD_NAMES = getIgnoredFieldNames();
    private static final List<String> DEPLOYMENT_JOB_IDS = new List<String>();

    private CustomMetadataSaver() {
        //static only
    }

    @InvocableMethod(
        category='Custom Metadata'
        label='Deploy Changes to Custom Metadata Records'
        description='Deploys changes to the list of custom metadata records'
    )
    public static void deploy(List<List<SObject>> customMetadataRecordsLists) {
        System.debug('customMetadataRecordsLists==' + customMetadataRecordsLists);

        List<SObject> consolidatedList = new List<SObject>();
        for (List<SObject> customMetadataRecordsList : customMetadataRecordsLists) {
            consolidatedList.addAll(customMetadataRecordsList);
        }

        System.debug('consolidatedList==' + consolidatedList);

        deploy(consolidatedList, null);
    }

    public static void deploy(List<SObject> customMetadataRecords) {
        deploy(customMetadataRecords, null);
    }

    public static void deploy(List<SObject> customMetadataRecords, Metadata.DeployCallback callback) {
        Metadata.DeployContainer deployment = new Metadata.DeployContainer();

        for (SObject customMetadataRecord : customMetadataRecords) {
            Metadata.CustomMetadata customMetadata = createDeployableCustomMetadata(customMetadataRecord);
            deployment.addMetadata(customMetadata);
        }

        String jobId = Test.isRunningTest() ? 'Fake Job ID' : Metadata.Operations.enqueueDeployment(deployment, callback);
        DEPLOYMENT_JOB_IDS.add(jobId);
        System.debug(LoggingLevel.INFO, 'Deployment Job ID: ' + jobId);
    }

    public static List<String> getDeploymentJobIds() {
        return DEPLOYMENT_JOB_IDS;
    }

    private static Set<String> getIgnoredFieldNames() {
        return new Set<String>{ 'DeveloperName', 'Id', 'Label', 'Language', 'MasterLabel', 'NamespacePrefix', 'QualifiedApiName' };
    }

    private static Metadata.CustomMetadata createDeployableCustomMetadata(SObject customMetadataRecord) {
        String customMetadataTypePrefix = customMetadataRecord.getSObjectType().getDescribe().getName().replace('__mdt', '');

        Metadata.CustomMetadata customMetadata = new Metadata.CustomMetadata();
        customMetadata.fullName = customMetadataTypePrefix + '.' + customMetadataRecord.get('DeveloperName');
        customMetadata.label = (String) customMetadataRecord.get('MasterLabel');

        for (String fieldName : customMetadataRecord.getPopulatedFieldsAsMap().keySet()) {
            if (IGNORED_FIELD_NAMES.contains(fieldName)) {
                continue;
            }

            Schema.SObjectField field = customMetadataRecord.getSObjectType().getDescribe().fields.getMap().get(fieldName);

            Object value;
            // Picklist values have to be cast to strings (even though they already look like strings)
            if (field.getDescribe().getType() == Schema.DisplayType.PICKLIST) {
                value = String.valueOf(customMetadataRecord.get(field));
            } else {
                value = customMetadataRecord.get(fieldName);
            }

            Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
            customField.field = fieldName;
            customField.value = value;
            System.debug(LoggingLevel.INFO, 'customField==' + customField);

            customMetadata.values.add(customField);
        }

        System.debug(LoggingLevel.INFO, 'customMetadata==' + customMetadata);

        return customMetadata;
    }
}
