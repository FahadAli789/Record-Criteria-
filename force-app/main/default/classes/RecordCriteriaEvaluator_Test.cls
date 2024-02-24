@isTest
public with sharing class RecordCriteriaEvaluator_Test {
    @isTest
    public static void evaluationCriteraShouldReturnCorrectValueForAllCases(){
        RecordCriteriaEvaluator evaluation = new RecordCriteriaEvaluator();
        Account acc = new Account(
            Name='Test Account 1',
            AnnualRevenue=1000,
            Rating='Hot'
        );
        for(Record_Criteria__c recordCriteria:makeSingleEvaluationRecordCriterias()){
            evaluation.setEvaluationRecord(recordCriteria).setSObject(acc);
            Assert.isTrue(evaluation.evaluationCritera('Field_1__c','Operation_1__c','Value_1__c'),'The evaluation should pass for'+ recordCriteria.Name);
        }
    }
    @isTest
    public static void evaluationShouldReturnCorrectOverallValue(){
        Map<String,Record_Criteria__c> evalutionRecordsWithMultipleCriteriaByScenarioNames =makeMultipleEvalutionRecordCriteriasByName();
        RecordCriteriaEvaluator evaluation = new RecordCriteriaEvaluator();
        Account acc = new Account(
            Name='Test Account 1',
            AnnualRevenue=1000,
            Rating='Hot'
        );
        evaluation.setSObject(acc);
        Assert.isFalse((evaluation.setEvaluationRecord(evalutionRecordsWithMultipleCriteriaByScenarioNames.get('Testing for 5 false criteria on AND Type'))).evaluate(),'Testing for 5 false criteria on AND Type should return false');
        Assert.isTrue((evaluation.setEvaluationRecord(evalutionRecordsWithMultipleCriteriaByScenarioNames.get('Testing for 5 true criteria on AND Type'))).evaluate(),'Testing for 5 true criteria on AND Type should return true');
        Assert.isFalse((evaluation.setEvaluationRecord(evalutionRecordsWithMultipleCriteriaByScenarioNames.get('Testing for 5 false criteria on OR Type'))).evaluate(),'Testing for 5 false criteria on OR Type should return false');
        Assert.isTrue((evaluation.setEvaluationRecord(evalutionRecordsWithMultipleCriteriaByScenarioNames.get('Testing for 5 true criteria on OR Type'))).evaluate(),'Testing for 5 true criteria on OR Type should return true');
        Assert.isFalse((evaluation.setEvaluationRecord(evalutionRecordsWithMultipleCriteriaByScenarioNames.get('Testing for 1 true criteria in middle on AND Type'))).evaluate(),'Testing for 1 true criteria in middle on AND Type should return false');
        Assert.isTrue((evaluation.setEvaluationRecord(evalutionRecordsWithMultipleCriteriaByScenarioNames.get('Testing for 1 true criteria in middle on OR Type'))).evaluate(),'Testing for 1 true criteria in middle on OR Type should return true');

    }
    public static List<Record_Criteria__c> makeSingleEvaluationRecordCriterias(){
        return new List<Record_Criteria__c>{
            new Record_Criteria__c(
                Name='Criteria 1',
                Field_1__c='AnnualRevenue',
                Operation_1__c='=',
                Value_1__c='1000'
            ),
            new Record_Criteria__c(
                Name='Criteria 2',
                Field_1__c='AnnualRevenue',
                Operation_1__c='>',
                Value_1__c='1'
            ),
            new Record_Criteria__c(
                Name='Criteria 3',
                Field_1__c='AnnualRevenue',
                Operation_1__c='<',
                Value_1__c='10000'
            ),
            new Record_Criteria__c(
                Name='Criteria 4',
                Field_1__c='AnnualRevenue',
                Operation_1__c='>=',
                Value_1__c='1000'
            ),
            new Record_Criteria__c(
                Name='Criteria 5',
                Field_1__c='AnnualRevenue',
                Operation_1__c='<=',
                Value_1__c='1000'
            ),
            new Record_Criteria__c(
                Name='Criteria 6',
                Field_1__c='Rating',
                Operation_1__c='Contains',
                Value_1__c='Hot'
            ),
            new Record_Criteria__c(
                Name='Criteria 7',
                Field_1__c='Rating',
                Operation_1__c='Contains Right ;',
                Value_1__c='Hot;Cold;Warm'
            )
        };
    }
    public static Map<String,Record_Criteria__c> makeMultipleEvalutionRecordCriteriasByName(){
        return new Map<String,Record_Criteria__c>{
            'Testing for 5 false criteria on AND Type' =>
            new Record_Criteria__c(
                Name='Testing for 5 false criteria on AND Type',
                Field_1__c='AnnualRevenue',
                Operation_1__c='=',
                Value_1__c='1',
                Field_2__c='AnnualRevenue',
                Operation_2__c='=',
                Value_2__c='1',
                Field_3__c='AnnualRevenue',
                Operation_3__c='=',
                Value_3__c='1',
                Field_4__c='AnnualRevenue',
                Operation_4__c='=',
                Value_4__c='1',
                Field_5__c='AnnualRevenue',
                Operation_5__c='=',
                Value_5__c='1',
                Number_of_Criteria__c=5,
                Overall_Operation__c='AND'
            ),
            'Testing for 5 true criteria on AND Type' =>
            new Record_Criteria__c(
                Name='Testing for 5 true criteria on AND Type',
                Field_1__c='AnnualRevenue',
                Operation_1__c='=',
                Value_1__c='1000',
                Field_2__c='AnnualRevenue',
                Operation_2__c='=',
                Value_2__c='1000',
                Field_3__c='AnnualRevenue',
                Operation_3__c='=',
                Value_3__c='1000',
                Field_4__c='AnnualRevenue',
                Operation_4__c='=',
                Value_4__c='1000',
                Field_5__c='AnnualRevenue',
                Operation_5__c='=',
                Value_5__c='1000',
                Number_of_Criteria__c=5,
                Overall_Operation__c='AND'
            ),
            'Testing for 5 false criteria on OR Type' =>
            new Record_Criteria__c(
                Name='Testing for 5 false criteria on OR Type',
                Field_1__c='AnnualRevenue',
                Operation_1__c='=',
                Value_1__c='1',
                Field_2__c='AnnualRevenue',
                Operation_2__c='=',
                Value_2__c='1',
                Field_3__c='AnnualRevenue',
                Operation_3__c='=',
                Value_3__c='1',
                Field_4__c='AnnualRevenue',
                Operation_4__c='=',
                Value_4__c='1',
                Field_5__c='AnnualRevenue',
                Operation_5__c='=',
                Value_5__c='1',
                Number_of_Criteria__c=5,
                Overall_Operation__c='OR'
            ),
            'Testing for 5 true criteria on OR Type' =>
            new Record_Criteria__c(
                Name='Testing for 5 true criteria on OR Type',
                Field_1__c='AnnualRevenue',
                Operation_1__c='=',
                Value_1__c='1000',
                Field_2__c='AnnualRevenue',
                Operation_2__c='=',
                Value_2__c='1000',
                Field_3__c='AnnualRevenue',
                Operation_3__c='=',
                Value_3__c='1000',
                Field_4__c='AnnualRevenue',
                Operation_4__c='=',
                Value_4__c='1000',
                Field_5__c='AnnualRevenue',
                Operation_5__c='=',
                Value_5__c='1000',
                Number_of_Criteria__c=5,
                Overall_Operation__c='OR'
            ),
            'Testing for 1 true criteria in middle on AND Type' =>
            new Record_Criteria__c(
                Name='Testing for 1 true criteria in middle on AND Type',
                Field_1__c='AnnualRevenue',
                Operation_1__c='=',
                Value_1__c='1',
                Field_2__c='AnnualRevenue',
                Operation_2__c='=',
                Value_2__c='1',
                Field_3__c='AnnualRevenue',
                Operation_3__c='=',
                Value_3__c='1',
                Field_4__c='AnnualRevenue',
                Operation_4__c='=',
                Value_4__c='1000',
                Field_5__c='AnnualRevenue',
                Operation_5__c='=',
                Value_5__c='1',
                Number_of_Criteria__c=5,
                Overall_Operation__c='AND'
            ),
            'Testing for 1 true criteria in middle on OR Type' =>
            new Record_Criteria__c(
                Name='Testing for 1 true criteria in middle on OR Type',
                Field_1__c='AnnualRevenue',
                Operation_1__c='=',
                Value_1__c='1',
                Field_2__c='AnnualRevenue',
                Operation_2__c='=',
                Value_2__c='1',
                Field_3__c='AnnualRevenue',
                Operation_3__c='=',
                Value_3__c='1',
                Field_4__c='AnnualRevenue',
                Operation_4__c='=',
                Value_4__c='1000',
                Field_5__c='AnnualRevenue',
                Operation_5__c='=',
                Value_5__c='1',
                Number_of_Criteria__c=5,
                Overall_Operation__c='OR'
            )
        };

    }
}