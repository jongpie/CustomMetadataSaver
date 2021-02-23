public inherited sharing class CustomMetadataEditor {
    public class FlowInput {
        @InvocableVariable
        public SObject customMetadataRecord;

        @InvocableVariable
        public String fieldName;

        @InvocableVariable
        public String fieldValue;
    }

    @invocableMethod
    public static void editCustomMetadata(List<FlowInput> inputs) {
        for(FlowInput input : inputs) {
            Schema.SObjectType sobjectType = input.customMetadataRecord.getSObjectType();
            Object value = getValue(sobjectType, input.fieldName, input.fieldValue);
            input.customMetadataRecord.put(input.fieldName, value);

            CustomMetadataSaver.addCustomMetadata(input.customMetadataRecord);
        }
    }

    private static Object getValue(Schema.SObjectType sobjectType, String fieldName, String fieldValue) {
        Schema.SObjectField field = sobjectType.getDescribe().fields.getMap().get(fieldName);

        switch on field.getDescribe().getSoapType() {
            when BOOLEAN {
                return Boolean.valueOf(fieldValue);
            }
            when else {
                return fieldValue;
            }
        }
    }
}
