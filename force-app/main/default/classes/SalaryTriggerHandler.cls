/*
*********************************************************
Apex Class Name    : SalaryTriggerHandler
Created Date       : March 03, 2023
@description       : This Class is the handler for SalaryTrigger.
                     This class calculates Total and Maximun Salary   
@author            : Selvazhaki Govindarasu
Modification Log:
Ver   Date             Author                               Modification
1.0   March 03, 2023   Selvazhaki Govindarasu               Initial Version
*********************************************************
*/
public class SalaryTriggerHandler {
    public static void onAfterInsert(List<Account_Salary__c> newList)
    {
        set<Id> acIds=new set<Id>();
        List<Account> acUpdate=new List<Account>();
        for(Account_Salary__c sal:newList)
        {
            if(sal.Account__c!=null)
            {
                acIds.add(sal.Account__c);
            }
        }
        acUpdate = TotalMaxSalary(acIds);
        
        if(!acUpdate.isEmpty())
        {
            update acUpdate;
        }
    }
    
    public static void onAfterUpdate(List<Account_Salary__c> newList, Map<Id,Account_Salary__c> oldMap )
    {
        Set<Id> acIds=new Set<Id>();
        List<Account> acUpdate=new List<Account>();
		for(Account_Salary__c sal:newList)
        {
            if(sal.Account__c!=null && sal.Salary__c !=oldMap.get(sal.Id).Salary__c) 
            {
                acIds.add(sal.Account__c);
            }
        }
        acUpdate = TotalMaxSalary(acIds);
        if(!acUpdate.isEmpty())
        {
            update acUpdate;
        }        
    }
    
    public static void onAfterDelete(List<Account_Salary__c> oldList)
    {
        Set<Id> acIds=new Set<Id>();
        List<Account> acUpdate=new List<Account>();
		for(Account_Salary__c sal:oldList)
        {
            if(sal.Account__c!=null) 
            {
                acIds.add(sal.Account__c);
            }
        }
        acUpdate = TotalMaxSalary(acIds);
        if(!acUpdate.isEmpty())
        {
            update acUpdate;
        }        
    }
    
// Method to calculate the Total Salary:
    public static List<Account> TotalMaxSalary(Set<Id> acIds)
    {
        List<Account> acUpdate = new List<Account>();
        Map <Id, Decimal> acSal=new Map <Id, Decimal>();
        
        for(Account_Salary__c sal:[Select Id, Salary__c, Account__c from Account_Salary__c where Account__c in:acIds])
        {
            Decimal total=0;
            if(acsal.containsKey(sal.Account__c))
            {
                total = acSal.get(sal.Account__c);
            }
            if(sal.Account__c != null)
            {
                total = total + sal.Salary__c;
            }
            acSal.put(sal.Account__c, total);
        }
        if(!acSal.isEmpty())
        {
           Map <Id, Decimal> acMxUpdate=new Map <Id, Decimal>();
            acMxUpdate = MaxSalary(acIds);
            for(Id i : acSal.keySet())
            {
                Account acct=new Account();
                acct.id =i;
                acct.Total_Salary__c = acSal.get(i);
                acct.Max_Salary__c =acMxUpdate.get(i);
                acUpdate.add(acct);
             }
        }
        
        
        return acUpdate;

    }
    // Method to calculate the Maximum Salary:
    public static Map<Id, Decimal> MaxSalary(Set<Id> acIds)
    {
      	//List<Account> acUpdate=new List<Account>();
      	Map <Id, Decimal> acMxSal=new Map <Id, Decimal>();
        for(AggregateResult Result : [SELECT Account__c, max(Salary__c)maxs FROM
                                  Account_Salary__c WHERE Account__c in:acIds GROUP BY Account__c])
               {
                    Account acc = new Account();
                    acc.Id = (String)Result.get('Account__c');
                    acc.Max_Salary__c= (Decimal)Result.get('maxs');
                    
                    //acUpdate.add(acc);
                    acMxSal.put(acc.Id, acc.Max_Salary__c);
       		   } 
               return acMxSal;
    
    }

}
