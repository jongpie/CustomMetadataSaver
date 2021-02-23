# Custom Metadata Saver for Apex and Flow

This is a small library that can be used in Salesforce to update & deploy changes to custom metadata types (CMDT).

## Flow
2 actions have to be called
 * `CustomMetadataEditor.editCustomMetadata()` - this is used to update a field on the custom metadata record. This is needed because Salesforce ignores any field changes on CMDT made in Flow.
    * customMetadataRecord - The CMDT record to update. Your flow should handle querying this.
    * fieldName - The API name of the field to update
    * fieldValue - The new value to use for the field
 * `CustomMetadataSaver.deployCustomMetadata()` - this will deploy any changes custom metadata records

## Apex
Since Apex can already update custom metadata records (it just can't save/deploy the changes), it's a little easier to deploy the changes from Apex.
 * First, update your CMDT record's field values, then call the method `CustomMetadataSaver.addCustomMetadata(customMetadataRecord)`. You can call this method multiple times if you are updating multiple CMDT records
 * When you have finished making changes to the CMDT records, call `CustomMetadataSaver.deployCustomMetadata()` to start the async deployment.