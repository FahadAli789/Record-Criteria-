public with sharing class RecordCriteriaEvaluator {
    private Record_Criteria__c recordCriteriaForEvaluation;
    private SObject recordForEvaluation;
    public RecordCriteriaEvaluator setEvaluationRecord(Record_Criteria__c recordCriteriaForEvaluation){
        this.recordCriteriaForEvaluation=recordCriteriaForEvaluation;
        return this;
    }
    public RecordCriteriaEvaluator setSObject(SObject recordForEvaluation){
        // Need to put a check that the Sobject does not match.
        this.recordForEvaluation=recordForEvaluation;
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
    @testVisible
    private Boolean evaluationCritera(String fieldKey,String operationFieldName,String valueFieldName){
        String operationType =(String) recordCriteriaForEvaluation.get(operationFieldName);
        Object recordForEvaluationFieldValue=recordForEvaluation.get((String) recordCriteriaForEvaluation.get(fieldKey));
        Object value= recordCriteriaForEvaluation.get(valueFieldName);
        switch on operationType {
            when '=' {
                return (Decimal) recordForEvaluationFieldValue == Decimal.valueOf(((String)value));
            }
            when '>'{
                return  (Decimal) recordForEvaluationFieldValue> Decimal.valueOf(((String)value));
            }
            when '<' {
                return (Decimal)recordForEvaluationFieldValue < Decimal.valueOf(((String)value));
            }
            when '>=' {
                return (Decimal)recordForEvaluationFieldValue >= Decimal.valueOf(((String)value));
            }
            when '<=' {
                return (Decimal)recordForEvaluationFieldValue <= Decimal.valueOf(((String)value));
            }
            when 'Contains'{
                return ((String)recordForEvaluationFieldValue).contains((String) value);
            }
            when 'Contains Right ;'{
                return valuesAsSet((String)value).contains((String) recordForEvaluationFieldValue);
            }
            when else{
                return false;
            }
        }
    }
    private Set<String> valuesAsSet(String valuesString){
        Set<String> valuesAsSet = new Set<String>();
        valuesAsSet.addAll(valuesString.removeEnd(';').split(';'));
        return valuesAsSet;
    } 
}