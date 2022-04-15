//trigger to prevent duplication of account
trigger trg1 on Account(after Insert,after update)
{
    if(checkRecursive.runOnce())
    {
   Set<Id> accId = new Set<Id>();
    Set<Id> acctId = new Set<Id>();
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate))
    {
        for(Account acc : trigger.new)
        {
            if( acc.ParentId != null)
            {
               accId.add(acc.ParentId); 
                acctId.add(acc.Id);
            }
        }
    }
   List<Account> accList = new List<Account>();
    Map<Id,Account> accMap = new Map<Id,Account>([Select ParentId,Id,Description from Account where Id IN : accId]);
    List<Account> acctList = [Select Id,ParentId,Description from Account where ParentId IN : accId];
    for(Account acc : acctList)
    {
      Account ac  = accMap.get(acc.ParentId);
        ac.Description = acc.Description;
        System.debug('Description-->'+ac.Description);
        accList.add(ac);
    }
    update accList;
}
}
