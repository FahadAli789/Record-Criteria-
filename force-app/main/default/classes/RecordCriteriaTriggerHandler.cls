public with sharing class RecordCriteriaTriggerHandler {
    public static void beforeInsert(List<Record_Criteria__c> newRecords){
        for(Record_Criteria__c recordCriteria:newRecords){
            new NumberOfCriteriaCalculator(recordCriteria);
        }
    }
    public static void beforeUpdate(List<Record_Criteria__c> newRecords,Map<Id,SObject> oldRecordMap){
        for(Record_Criteria__c recordCriteria:newRecords){
            new NumberOfCriteriaCalculator(recordCriteria);
        }
    }
    public class NumberOfCriteriaCalculator{
        private Record_Criteria__c recordCriteria;
        private final Integer MAX_NO_OF_FIELDS=5;
        public NumberOfCriteriaCalculator(Record_Criteria__c recordCriteria){
            this.recordCriteria=recordCriteria;
            this.recordCriteria.Number_of_Criteria__c=calculateNumberOfCriteria();
        }
        @testvisible
        private Integer calculateNumberOfCriteria(){
            Integer counter=0;
            for(;counter<MAX_NO_OF_FIELDS;++counter){
                String fieldKey='Field_'+(counter+1)+'__c';   
                if(recordCriteria.get(fieldKey)!=null && !String.isBlank((String) recordCriteria.get(fieldKey))){
                    continue;
                }            
                return counter;             
            }
            return counter;
        }
    }
}