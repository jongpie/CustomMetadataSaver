public inherited sharing class CustomMetadataSaver {

    private static List<SObject> customMetadataRecords = new List<SObject>();

    public static void addCustomMetadata(SObject customMetadataRecord) {
        customMetadataRecords.add(customMetadataRecord);
    }

    @invocableMethod
    public static void deployCustomMetadata() {
        Metadata.DeployContainer deployment = new Metadata.DeployContainer();

        for (SObject customMetadataRecord : customMetadataRecords) {
            String customMetadataTypePrefix = customMetadataRecord.getSObjectType().getDescribe().getName().replace('__mdt', '');

            Metadata.CustomMetadata customMetadata = new Metadata.CustomMetadata();
            customMetadata.fullName = customMetadataTypePrefix + '.' + customMetadataRecord.get('DeveloperName');
            customMetadata.label = (String) customMetadataRecord.get('MasterLabel');

            for (String fieldName : customMetadataRecord.getPopulatedFieldsAsMap().keySet()) {
                Set<String> ignoredFieldNames = new Set<String>{'Id', 'DeveloperName', 'MasterLabel', 'Label', 'Language', 'NamespacePrefix', 'QualifiedApiName'};
                if(ignoredFieldNames.contains(fieldName)) {
                    continue;
                }

                // if(customMetadataRecord.getSObjectType().getDescribe().fields.getMap().get(fieldName).getDescribe().isUpdateable() == false) {
                //     continue;
                // }

                Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
                customField.field = fieldName;
                customField.value = customMetadataRecord.getPopulatedFieldsAsMap().get(fieldName);
                System.debug(LoggingLevel.INFO, 'customField==' + customField);

                customMetadata.values.add(customField);
            }

            System.debug(LoggingLevel.INFO, 'customMetadata==' + customMetadata);
            deployment.addMetadata(customMetadata);
        }
        // TODO maybe add an instance of Metadata.DeployCallback to use as a callback - for now, use null
        Id jobId = Metadata.Operations.enqueueDeployment(deployment, null);
        System.debug(LoggingLevel.INFO, 'Deployment Job ID: ' + jobId);
    }

}
