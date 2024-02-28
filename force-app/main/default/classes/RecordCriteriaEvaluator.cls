public with sharing class RecordCriteriaEvaluator {
    private Record_Criteria__c recordCriteriaForEvaluation;
    private SObject recordForEvaluation;
    private Map<String,Boolean> alreadyCalculatedResultByEvaluationCriteria = new Map<String,Boolean>();
    public RecordCriteriaEvaluator setEvaluationRecord(Record_Criteria__c recordCriteriaForEvaluation){
        this.recordCriteriaForEvaluation=recordCriteriaForEvaluation;
        return this;
    }
    public RecordCriteriaEvaluator setSObject(SObject recordForEvaluation){
        // Need to put a check that the Sobject does not match.
        this.recordForEvaluation=recordForEvaluation;
        clearMap();
        return this;
    }
    public Boolean evaluate(){
        for(Integer counter=0;counter<recordCriteriaForEvaluation.Number_of_Criteria__c;++counter){
            String fieldKey='Field_'+(counter+1)+'__c';
            String operationFieldName='Operation_'+(counter+1)+'__c';
            String valueFieldName='Value_'+(counter+1)+'__c';
            if(!evaluationCritera(fieldKey,operationFieldName,valueFieldName) && recordCriteriaForEvaluation.Overall_Operation__c =='AND'){
                return false;
            }
            else if(evaluationCritera(fieldKey,operationFieldName,valueFieldName) && recordCriteriaForEvaluation.Overall_Operation__c=='OR'){
                return true;
            }
        }
        if(recordCriteriaForEvaluation.Overall_Operation__c =='AND'){
            return true;
        } 
        else{
            return false;
        }
    }
    @TestVisible
    private void clearMap(){
        alreadyCalculatedResultByEvaluationCriteria.clear();
    }
    @testVisible
    private Boolean evaluationCritera(String fieldKey,String operationFieldName,String valueFieldName){
        String operationType =(String) recordCriteriaForEvaluation.get(operationFieldName);
        String recordForEvaluationFieldApiName=(String) recordCriteriaForEvaluation.get(fieldKey);
        Object value= recordCriteriaForEvaluation.get(valueFieldName);
        if(alreadyCalculatedResultByEvaluationCriteria.containsKey(recordForEvaluationFieldApiName+operationType+(String) value)){
            return alreadyCalculatedResultByEvaluationCriteria.get(recordForEvaluationFieldApiName+operationType+(String) value);
        }
        Boolean result;
        FieldInformation fieldInformation = new FieldInformation(recordForEvaluation,recordForEvaluationFieldApiName);
        Schema.SObjectField currentField= fieldInformation.getField();
        Object fieldValue=fieldInformation.getValue();
        switch on currentField.getDescribe().getSoapType() {
            when DOUBLE,INTEGER {
                 result=compareNumber((Decimal) fieldValue,operationType,Decimal.valueOf((String) value));
            }
            when STRING{
                 result=compareString((String) fieldValue,operationType,(String) value);
            }
            when else{
                throw new RecordCriteriaEvaluatorException('Illegal Data Type For Comparison');
            }
        }
        alreadyCalculatedResultByEvaluationCriteria.put(recordForEvaluationFieldApiName+operationType+(String) value,result) ;
        return result; 
    }
    private Boolean compareNumber(Decimal fieldValue,String operationType,Decimal value){

        switch on operationType {
            when '=' {
                return fieldValue == value;
            }
            when '>'{
                return fieldValue > value;
            }
            when '<'{
                return fieldValue < value;
            }
            when '>='{
                return fieldValue >= value;
            }
            when '<='{
                return fieldValue <= value;
            }
            when else {
                throw new RecordCriteriaEvaluatorException('Illegal Operation Type('+operationType+') For Number');
            }
        }
    }
    private Boolean compareString(String fieldValue,String operationType,String value){
        switch on operationType{
            when '='{
                return fieldValue == value;
            }
            when 'Contains'{
                return fieldValue.contains(value);
            }
            when 'Right Contains'{
                return valuesAsSet(value).contains(fieldValue);
            }
            when else {
                throw new RecordCriteriaEvaluatorException('Illegal Operation Type('+operationType+') For String ');
            }
        }
    }
    private Set<String> valuesAsSet(String valuesString){
        Set<String> valuesAsSet = new Set<String>();
        valuesAsSet.addAll(valuesString.removeEnd(';').split(';'));
        return valuesAsSet;
    } 
    public class FieldInformation{
        private Schema.SObjectType sobjectType;
        private String fieldApiName;
        private String fieldValue;
        private Sobject  record;
        public FieldInformation(Sobject record, String fieldApiName){
            this.sobjectType = record.getSObjectType();
            this.record=record;
            this.fieldApiName=fieldApiName;
        }
        public Schema.SObjectField getField(){
            return this.sobjectType.getDescribe().fields.getMap().get(fieldApiName);
        }
        public Object getValue(){
            if(!fieldApiName.contains('.')){
                return record.get(fieldApiName);
            }
            else{
                return getValueOfImmediateParentField();
            }
        }
        private Object getValueOfImmediateParentField(){
            List<String> splitFields = fieldApiName.split('\\.');
            String parentFieldName=splitFields[0];
            String childFieldName=splitFields[1];
            if(parentFieldName.endsWith('__r')){
                parentFieldName=parentFieldName.remove('__r')+'__c';
            }
            else{
                parentFieldName=parentFieldName+'Id';
            }
            Schema.SObjectField parentField=sobjectType.getDescribe().fields.getMap().get(parentFieldName);
            Sobject parentRecord=(Sobject) record.getSobject(parentField);
            return parentRecord.get(childFieldName);
        }
    }

    public class RecordCriteriaEvaluatorException extends Exception{
    }
}