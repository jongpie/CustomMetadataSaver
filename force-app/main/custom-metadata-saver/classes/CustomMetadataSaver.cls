//----------------------------------------------------------------------------------------------------//
// This file is part of the Custom Metadata Saver project, released under the MIT License.            //
// See LICENSE file or go to https://github.com/jongpie/CustomMetadataSaver for full license details. //
//----------------------------------------------------------------------------------------------------//

public inherited sharing class CustomMetadataSaver {
    private static final Map<String, SObject> CUSTOM_METADATAR_RECORDS_BY_NAME = new Map<String, SObject>();
    private static final Set<String> IGNORED_FIELD_NAMES = getIgnoredFieldNames();
    private static final List<Id> DEPLOYMENT_JOB_IDS = new List<Id>();

    public static SObject getInstance(SObject customMetadataRecord) {
        String fullName = getFullName(customMetadataRecord);
        return CUSTOM_METADATAR_RECORDS_BY_NAME.get(fullName);
    }

    public static Map<String, SObject> getAll() {
        return CUSTOM_METADATAR_RECORDS_BY_NAME;
    }

    public static void addAll(List<SObject> customMetadataRecords) {
        for (SObject customMetadataRecord : customMetadataRecords) {
            addInstance(customMetadataRecord);
        }
    }

    public static void addInstance(SObject customMetadataRecord) {
        String fullName = getFullName(customMetadataRecord);

        customMetadataRecord = customMetadataRecord.clone();
        CUSTOM_METADATAR_RECORDS_BY_NAME.put(fullName, customMetadataRecord);
    }

    public static void updateInstance(SObject customMetadataRecord, SObjectField field, Object value) {
        String fullName = getFullName(customMetadataRecord);

        if (CUSTOM_METADATAR_RECORDS_BY_NAME.containsKey(fullName) == false) {
            addInstance(customMetadataRecord);
        }

        customMetadataRecord = getInstance(customMetadataRecord);
        customMetadataRecord.put(field, value);
    }

    @InvocableMethod(
        category='Custom Metadata'
        label='Deploy Changes to Custom Metadata Records'
        description='Deploys changes to any custom metadata records that have been added via addCustomMetadata()'
    )
    public static void deploy() {
        // TODO maybe add an internal instance of Metadata.DeployCallback to use as a default callback
        deploy(null);
    }

    public static void deploy(Metadata.DeployCallback callback) {
        Metadata.DeployContainer deployment = new Metadata.DeployContainer();

        for (SObject customMetadataRecord : CUSTOM_METADATAR_RECORDS_BY_NAME.values()) {
            Metadata.CustomMetadata customMetadata = createDeployableCustomMetadata(customMetadataRecord);
            deployment.addMetadata(customMetadata);
        }

        Id jobId = Test.isRunningTest() ? null : Metadata.Operations.enqueueDeployment(deployment, callback);
        DEPLOYMENT_JOB_IDS.add(jobId);
        System.debug(LoggingLevel.INFO, 'Deployment Job ID: ' + jobId);

        // Clear out the cached CMDT records after they've been saved
        CUSTOM_METADATAR_RECORDS_BY_NAME.clear();
    }

    public static List<Id> getDeploymentJobIds() {
        return DEPLOYMENT_JOB_IDS;
    }

    private static Set<String> getIgnoredFieldNames() {
        return new Set<String>{ 'DeveloperName', 'Id', 'Label', 'Language', 'MasterLabel', 'NamespacePrefix', 'QualifiedApiName' };
    }

    private static String getFullName(SObject customMetadataRecord) {
        String customMetadataTypePrefix = customMetadataRecord.getSObjectType().getDescribe().getName().replace('__mdt', '');
        return customMetadataTypePrefix + '.' + customMetadataRecord.get('DeveloperName');
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

            Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
            customField.field = fieldName;
            customField.value = customMetadataRecord.getPopulatedFieldsAsMap().get(fieldName);
            System.debug(LoggingLevel.INFO, 'customField==' + customField);

            customMetadata.values.add(customField);
        }

        System.debug(LoggingLevel.INFO, 'customMetadata==' + customMetadata);

        return customMetadata;
    }
}
