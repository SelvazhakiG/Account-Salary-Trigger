
/*
*********************************************************
Apex Trigger Name  : Salary
Created Date       : March 03, 2023
@description       : This Trigger is for to calculating Total and
                     Maximum Salary for the related(Lookup) 
                     Account_Salary(Custom Object)
@author            : Selvazhaki Govindarasu
Modification Log:
Ver   Date             Author                               Modification
1.0   March 03, 2023   Selvazhaki Govindarasu               Initial Version
*********************************************************
*/
trigger Salary on Account_Salary__c (after insert, after update, after delete, after undelete) {
    if(Trigger.isAfter)
    {
        if(Trigger.isInsert || Trigger.isUndelete)
        {
            SalaryTriggerHandler.onAfterInsert(Trigger.New);
        }
        else if(Trigger.isUpdate)
        {
            SalaryTriggerHandler.onAfterUpdate(Trigger.New, Trigger.oldMap);
        }
        else if(Trigger.isDelete)
        {
            SalaryTriggerHandler.onAfterDelete(Trigger.Old);
        }
    }

}