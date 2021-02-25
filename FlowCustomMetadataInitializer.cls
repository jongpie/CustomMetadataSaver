public inherited sharing class FlowCustomMetadataInitializer {

    @InvocableMethod
    public static List<List<SObject>> enableEditing(List<List<SObject>> customMetadataRecordsLists) {
        System.debug('customMetadataRecordsLists==' + customMetadataRecordsLists);

        if(customMetadataRecordsLists == null) {
            return null;
        }

        if(customMetadataRecordsLists.get(0) == null) {
            return null;
        }

        List<List<SObject>> clonedCustomMetadataRecordsLists = new List<List<SObject>>();

        for(List<SObject> recordsList : customMetadataRecordsLists) {
            List<SObject> clonedRecords = new List<SObject>();
            for(SObject record : recordsList) {
                clonedRecords.add(record.clone());
            }
            CustomMetadataSaver.addAllInstances(clonedRecords);
            clonedCustomMetadataRecordsLists.add(clonedRecords);
        }

        return clonedCustomMetadataRecordsLists;



        // for(SObject customMetadataRecord : customMetadataRecordsLists.get(0)) {
        //     customMetadataRecord = customMetadataRecord.clone();
        // }
        // for(List<SObject> recordList : customMetadataRecordsLists) {
        //     CustomMetadataSaver.addCustomMetadata(recordList);
        // }
        // return customMetadataRecordsLists;
    }
}
