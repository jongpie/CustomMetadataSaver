//----------------------------------------------------------------------------------------------------//
// This file is part of the Custom Metadata Saver project, released under the MIT License.            //
// See LICENSE file or go to https://github.com/jongpie/CustomMetadataSaver for full license details. //
//----------------------------------------------------------------------------------------------------//

public inherited sharing class FlowCustomMetadataEditor {
    public class FlowInput {
        @InvocableVariable(required=true label='The custom metadata record to update')
        public SObject customMetadataRecord;

        @InvocableVariable(required=true label='The name of the field to update')
        public String fieldName;

        @InvocableVariable(required=true label='The value to use for the field')
        public String fieldValue;
    }

    @InvocableMethod(
        category='Custom Metadata'
        label='Update Field on a Custom Metadata Record'
        description='Provides the ability to update a field on a custom metadata record'
    )
    public static void editCustomMetadata(List<FlowInput> inputs) {
        System.debug('FlowCustomMetadataEditor inputs==' + inputs);

        for (FlowInput input : inputs) {
            Schema.SObjectType sobjectType = input.customMetadataRecord.getSObjectType();
            // TODO add proper handling/error throwing for invalid field names
            Schema.SObjectField field = sobjectType.getDescribe().fields.getMap().get(input.fieldName);
            Object value = getValue(sobjectType, field, input.fieldValue);


            CustomMetadataSaver.updateInstance(input.customMetadataRecord, field, value);
        }
    }

    private static Object getValue(Schema.SObjectType sobjectType, Schema.SObjectField field, String fieldValue) {
        switch on field.getDescribe().getSoapType() {
            when BOOLEAN {
                return Boolean.valueOf(fieldValue);
            }
            when DATE {
                return Date.parse(fieldValue);
            }
            when DATETIME {
                return Datetime.parse(fieldValue);
            }
            when DOUBLE {
                return Double.valueOf(fieldValue);
            }
            when ID {
                return Id.valueOf(fieldValue);
            }
            when INTEGER {
                return Integer.valueOf(fieldValue);
            }
            // FIXME Time.class does not have a `parse(String)` or `valueOf(String)` methods
            //       Look for options to implement
            // when TIME {
            //     return Time.valueOf(fieldValue);
            // }
            when else {
                return fieldValue;
            }
        }
    }
}
