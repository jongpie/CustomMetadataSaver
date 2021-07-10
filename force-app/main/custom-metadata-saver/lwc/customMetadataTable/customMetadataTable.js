import { LightningElement, api, wire } from 'lwc';
import getCMDTObjectInfo from '@salesforce/apex/CustomMetadataTableController.getCMDTObjectInfo';
import deploy from '@salesforce/apex/CustomMetadataTableController.deploy'

const columns = [
    { label: 'Developer Name', fieldName: 'DeveloperName', editable: false },
    { label: 'Label', fieldName: 'MasterLabel', editable: true },
    { label: 'ExampleDateField__c', fieldName: 'ExampleDateField__c', type: 'date', editable: true },
    { label: 'ExampleEmailField__c', fieldName: 'ExampleEmailField__c', type: 'email', editable: true },
    { label: 'ExamplePhoneField__c', fieldName: 'ExamplePhoneField__c', type: 'phone', editable: true },
    { label: 'ExampleURLField__c', fieldName: 'ExampleURLField__c', type: 'url', editable: true },
    // { label: 'Website', fieldName: 'website', type: 'url', editable: true },
    // { label: 'Phone', fieldName: 'phone', type: 'phone', editable: true },
    // { label: 'CloseAt', fieldName: 'closeAt', type: 'date', editable: true },
    // { label: 'Balance', fieldName: 'amount', type: 'currency', editable: true },
];

export default class CustomMetadataTable extends LightningElement {
    @api 
    records = [];

    @api
    inputVariables;

    @api
    genericTypeMappings;
    
    @api
    isDeploying = false;
    
    title = 'CMDT Object name';
    draftValues;
    deploymentId;
    
    defaultSortDirection = 'asc';
    sortedDirection
    sortedBy

    // data = [];
    columns = columns;

    // eslint-disable-next-line @lwc/lwc/no-async-await
    async connectedCallback() {
        // this.data = await fetchDataHelper({ amountOfRecords: 100 });
    }

    @wire(getCMDTObjectInfo, {
        cmdtRecord: '$cmdtRecord'
    })
    wiredObjectInfo(result) {
        if (result.data) {
            // let queryResult = this.processResult(result.data);
            // this.queryResult = queryResult;
            // this.showComponent = queryResult.isAccessible;
            // this.title = queryResult.labelPlural + ' (' + queryResult.totalLogEntriesCount + ' Total)';
        } else if (result.error) {
            // this.logEntryData = undefined;
            // this.logEntryColumns = undefined;
            // console.log(result.error);
        }
    }

    // call deploy method imperatively
    handleDeploy(updatedRecords) {
        // console.log('handleDeploy() -- this.records');
        // console.table(this.records);
        // console.log(JSON.stringify(this.records));
        console.log('handleDeploy() -- updatedRecords');
        console.table(updatedRecords);
        console.log(JSON.stringify(updatedRecords));

        

        deploy({ customMetadataRecords: updatedRecords })
            .then(result => {
                console.log('result==' + result);
                this.deploymentId = result;
                this.isDeploying = true;
            })
            .catch(error => {
                this.error = error;
            });
    }

    // https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.use_flow_custom_property_editor_sobject_lwc_example
    get typeOptions() {
        return [
            { label: 'Account', value: 'Account' },
            { label: 'Case', value: 'Case' },
            { label: 'Lead', value: 'Lead' },
        ];
    }

    get inputType() {
        // const type = this.genericTypeMappings.find(
        //     ({ typeName }) => typeName === 'T'
        // );
        // return type && type.typeValue;
        return '';
    }
    handleInputTypeChange(event) {
        if (event && event.detail) {
            const newValue = event.detail.value;
            const typeChangedEvent = new CustomEvent(
                'configuration_editor_generic_type_mapping_changed',
                {
                    bubbles: true,
                    cancelable: false,
                    composed: true,
                    detail: {
                        typeName: 'T',
                        typeValue: newValue
                    },
                }
            );
        this.dispatchEvent(typeChangedEvent);
        }
    }

    handleSave(event) {
        console.log('event.detail.draftValues');
        console.table(event.detail.draftValues);
        console.log(JSON.stringify(event.detail.draftValues));
        
        // Next, combine draft values with original object
        // Example JSON of draft values:
        // [{"ExampleEmailField__c":"asdfsd@test.com","DeveloperName":"No_Fields_Populated"}]
        let updatedRecords = this.handleRecordChanges(event.detail.draftValues);
        // Next, update this.records
        
        // And finally, deploy only changed records (if any)
        
        // this.isDeploying = true;
        console.log('TODO deploy CMDT records');
        console.log(JSON.stringify(updatedRecords));
        console.log('and now calling handleDeploy()');
        this.handleDeploy(updatedRecords);
        // this.isDeploying = false;
        console.log('this.draftValues');
        console.table('this.draftValues==' + JSON.stringify(this.draftValues));

        // this.template.querySelector("lightning-datatable").data = this.records;
        this.template.querySelector("lightning-datatable").draftValues = [];
    }

    handleRecordChanges(draftValues) {
        console.log('draftValues==');
        console.log(JSON.stringify(draftValues));

        var draftValuesByDeveloperName = draftValues.reduce(function(map, obj) {
            console.log('obj');
            console.log(obj);
            map[obj.DeveloperName] = obj;
            return map;
        }, {});
        console.log('draftValuesByDeveloperName==');
        console.log(JSON.stringify(draftValuesByDeveloperName));

        let allRecords = [];
        let updatedRecords = [];
        this.records.forEach((record) => {
            console.log('gonna update a record');
            console.log(JSON.stringify(record));

            let devName = record.DeveloperName;
            console.log('devName==' + devName);
            let recordDraftValues = draftValuesByDeveloperName[devName];
            console.log('recordDraftValues==');
            console.log(JSON.stringify(recordDraftValues));
            if (recordDraftValues != null) {
                // recordDraftValues.forEach((draftValue, index) => {
                //     record = {...record, ...draftValues};
                // });
                console.log('doing it!')
                console.log('current record==' + JSON.stringify(record));
                console.log('current draftValues==' + JSON.stringify(recordDraftValues));
                let updatedRecord = {...record, ...recordDraftValues};
                
                // Object.keys(recordDraftValues)
                //     // .forEach(key => record[key] = recordDraftValues[key]);
                //     .forEach((key, index) => {
                //         console.log(`Current index: ${index}`);
                //         console.log('current key==' + key);
                //         record[key] = recordDraftValues[key];
                //     });
                console.log('updated record==' + JSON.stringify(updatedRecord));
                updatedRecords.push(updatedRecord);
            }

        });

        return updatedRecords;

    }

    handleSort(event) {

    }
}
