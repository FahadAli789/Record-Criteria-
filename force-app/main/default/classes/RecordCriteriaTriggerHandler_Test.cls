@isTest
public with sharing class RecordCriteriaTriggerHandler_Test {
    @isTest
    public static void triggerContextMethodsShouldRun(){
        List<Record_Criteria__c> recordCriterias=makeCriteriaWithIncrementalNoOfFieldsPopulated().values();
        insert recordCriterias;
        update recordCriterias;
    }
   @isTest 
   public static void numberOfCriteriaCalculatorShouldGiveCorrectNumberOfCriteria(){
    Map<String,Record_Criteria__c> recordCriteriasByScenarioName=makeCriteriaWithIncrementalNoOfFieldsPopulated();
    new RecordCriteriaTriggerHandler.NumberOfCriteriaCalculator(recordCriteriasByScenarioName.get('Zero Criteria'));
    Assert.areEqual(0, recordCriteriasByScenarioName.get('Zero Criteria').Number_of_Criteria__c,'The count should match' );
    new RecordCriteriaTriggerHandler.NumberOfCriteriaCalculator(recordCriteriasByScenarioName.get('One Criteria'));
    Assert.areEqual(1, recordCriteriasByScenarioName.get('One Criteria').Number_of_Criteria__c,'The count should match' );
    new RecordCriteriaTriggerHandler.NumberOfCriteriaCalculator(recordCriteriasByScenarioName.get('Two Criteria'));
    Assert.areEqual(2, recordCriteriasByScenarioName.get('Two Criteria').Number_of_Criteria__c,'The count should match' );
    new RecordCriteriaTriggerHandler.NumberOfCriteriaCalculator(recordCriteriasByScenarioName.get('Three Criteria'));
    Assert.areEqual(3, recordCriteriasByScenarioName.get('Three Criteria').Number_of_Criteria__c,'The count should match' );
    new RecordCriteriaTriggerHandler.NumberOfCriteriaCalculator(recordCriteriasByScenarioName.get('Four Criteria'));
    Assert.areEqual(4, recordCriteriasByScenarioName.get('Four Criteria').Number_of_Criteria__c,'The count should match' );
    new RecordCriteriaTriggerHandler.NumberOfCriteriaCalculator(recordCriteriasByScenarioName.get('Five Criteria'));
    Assert.areEqual(5, recordCriteriasByScenarioName.get('Five Criteria').Number_of_Criteria__c,'The count should match' );
    new RecordCriteriaTriggerHandler.NumberOfCriteriaCalculator(recordCriteriasByScenarioName.get('Blank Criteria 3'));
    Assert.areEqual(2,recordCriteriasByScenarioName.get('Blank Criteria 3').Number_of_Criteria__c ,'The count should match' );
   }
   @isTest
   public static Map<String,Record_Criteria__c> makeCriteriaWithIncrementalNoOfFieldsPopulated(){
    return new Map<String,Record_Criteria__c>{
        'Zero Criteria' =>
        new Record_Criteria__c(
                Name='Zero Criteria'
        ),
        'One Criteria' =>
        new Record_Criteria__c(
                Name='One Criteria',
                Field_1__c='AnnualRevenue'
        ),
        'Two Criteria' =>
        new Record_Criteria__c(
                Name='Two Criteria',
                Field_1__c='AnnualRevenue',
                Field_2__c='AnnualRevenue'
        ),
        'Three Criteria' =>
        new Record_Criteria__c(
                Name='Three Criteria',
                Field_1__c='AnnualRevenue',
                Field_2__c='AnnualRevenue',
                Field_3__c='AnnualRevenue'
        ),
        'Four Criteria' =>
        new Record_Criteria__c(
                Name='Four Criteria',
                Field_1__c='AnnualRevenue',
                Field_2__c='AnnualRevenue',
                Field_3__c='AnnualRevenue',
                Field_4__c='AnnualRevenue'
                
        ),
        'Five Criteria' =>
        new Record_Criteria__c(
                Name='Five Criteria',
                Field_1__c='AnnualRevenue',
                Field_2__c='AnnualRevenue',
                Field_3__c='AnnualRevenue',
                Field_4__c='AnnualRevenue',
                Field_5__c='AnnualRevenue'
        ),
        'Blank Criteria 3' =>
        new Record_Criteria__c(
                Name='Blank Criteria 3',
                Field_1__c='AnnualRevenue',
                Field_2__c='AnnualRevenue',
                Field_3__c=''
        )
    };
   }
}