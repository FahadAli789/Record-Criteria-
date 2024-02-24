trigger RecordCriteriaTrigger on Record_Criteria__c (before insert,before update) {
    if(Trigger.isBefore && Trigger.isInsert){
        RecordCriteriaTriggerHandler.beforeInsert(Trigger.new);
    }
    if(Trigger.isBefore && Trigger.isUpdate){
        RecordCriteriaTriggerHandler.beforeUpdate(Trigger.new,Trigger.oldMap);
    }
}