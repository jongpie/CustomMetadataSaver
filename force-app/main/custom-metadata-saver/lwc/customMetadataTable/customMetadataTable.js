import { LightningElement, api, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import deploy from '@salesforce/apex/CustomMetadataTableController.deploy';

const columns = [
    { label: 'Developer Name', fieldName: 'DeveloperName', editable: false },
    { label: 'Label', fieldName: 'MasterLabel', editable: true },
    { label: 'ExampleCheckboxField__c', fieldName: 'ExampleCheckboxField__c', type: 'checkbox', editable: true },
    { label: 'ExampleDateField__c', fieldName: 'ExampleDateField__c', type: 'date', editable: true },
    { label: 'ExampleDatetimeField__c', fieldName: 'ExampleDatetimeField__c', type: 'datetime', editable: true },
    { label: 'ExampleEmailField__c', fieldName: 'ExampleEmailField__c', type: 'email', editable: true },
    { label: 'ExampleNumberField__c', fieldName: 'ExampleNumberField__c', type: 'number', editable: true },
    { label: 'ExamplePercentField__c', fieldName: 'ExamplePercentField__c', type: 'percent', editable: true },
    { label: 'ExamplePhoneField__c', fieldName: 'ExamplePhoneField__c', type: 'phone', editable: true },
    { label: 'ExamplePicklistField__c', fieldName: 'ExamplePicklistField__c', type: 'picklist', editable: true },
    { label: 'ExampleTextAreaField__c', fieldName: 'ExampleTextAreaField__c', type: 'textarea', editable: true },
    { label: 'ExampleTextAreaLongField__c', fieldName: 'ExampleTextAreaLongField__c', type: 'textarea', editable: true },
    { label: 'ExampleTextField__c', fieldName: 'ExampleTextField__c', type: 'text', editable: true },
    { label: 'ExampleURLField__c', fieldName: 'ExampleURLField__c', type: 'url', editable: true }
];

export default class CustomMetadataTable extends LightningElement {
    // TODO remove hardcoding
    @api
    objectApiName = 'CustomMetadataDeployTest__mdt';

    @api
    title = '';

    @api
    fieldsToDisplay = '';

    @api
    records = [];

    columns = columns;
    defaultSortDirection = 'asc';
    sortedDirection;
    sortedBy;

    isDeploying = false;
    deploymentId;
    deploymentLink;

    _sobjectDescribe;
    _sobjectFieldsByDeveloperName = new Map();

    @wire(getObjectInfo, { objectApiName: '$objectApiName' })
    currentObjectWire({ error, data }) {
        if (error) {
            // TODO add error handling
            console.log('an error occurred');
        } else if (data) {
            this._sobjectDescribe = data;

            this._sobjectFieldsByDeveloperName = new Map(Object.entries(this._sobjectDescribe.fields));
            console.log('object info1!');
            console.log(this._sobjectDescribe);
            console.log(this._sobjectFieldsByDeveloperName);
            this._setTitle();
            this._loadDisplayFields();
        }
    }

    handleSort(event) {
        // TODO
    }

    handleSave(event) {
        let updatedRecords = this._mergeDraftRecordChanges(event.detail.draftValues);
        if (updatedRecords.length > 0) {
            this._deployCustomMetadataRecords(updatedRecords);
        }
    }

    _setTitle() {
        if (!this.title) {
            this.title = this._sobjectDescribe.label;
        }
    }

    _loadDisplayFields() {
        console.log('running _loadDisplayFields()');

        let columnsToDisplay = [];
        this.fieldsToDisplay
            .replace(' ', '')
            .split(',')
            .forEach(fieldApiName => {
                console.log('current fieldApiName==' + fieldApiName);
                let field = this._sobjectFieldsByDeveloperName.get(fieldApiName);
                console.log('current field==' + field);
                // let column = {
                //     label: field.label,
                //     fieldName: fieldApiName,
                //     editable: true,
                //     type: field.dataType.toLowerCase()
                // };
                // columnsToDisplay.push(column);
            });
        console.log('columnsToDisplay==' + columnsToDisplay);
        // this.columns = columnsToDisplay;
    }

    _mergeDraftRecordChanges(draftValues) {
        var draftValuesByDeveloperName = draftValues.reduce(function (map, obj) {
            map[obj.DeveloperName] = obj;
            return map;
        }, {});

        let allRecords = [];
        let updatedRecords = [];
        this.records.forEach(record => {
            let recordDraftValues = draftValuesByDeveloperName[record.DeveloperName];
            if (recordDraftValues != null) {
                let updatedRecord = { ...record, ...recordDraftValues };
                updatedRecords.push(updatedRecord);
            }
        });

        return updatedRecords;
    }

    // call deploy method imperatively
    _deployCustomMetadataRecords(updatedRecords) {
        deploy({ customMetadataRecords: updatedRecords })
            .then(result => {
                console.log('result==' + result);
                this.deploymentId = result;
                this.deploymentLink = '/' + result;
                this.isDeploying = true;
            })
            .catch(error => {
                this.error = error;
            });
    }

    async _checkDeploymentStatus() {
        let deploymentFinished = false;
        // TODO add retry/timeout check to see if deployment job is finished
        if (deploymentFinished) {
            this.template.querySelector('lightning-datatable').draftValues = [];
        }
    }
}
