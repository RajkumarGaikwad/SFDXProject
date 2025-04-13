public class BadCode {

    Integer i = 0;
    public List<Account> a;

    public void DoStuff(){
        List<Account> accs = [SELECT Id, Name FROM Account]; // hardcoded SOQL
        for(Account acc : accs){
            System.debug('Account is: ' + acc.Name); // debug in production
        }
        if(true){
            // empty if block
        }

        for(Integer i=0;i<10;i++){
            Contact c = [SELECT Id FROM Contact WHERE LastName = 'Smith']; // SOQL in loop
            c.FirstName = 'John';
            update c; // DML in loop
        }
    }

    public void helper(){
        String temp = 'temp';
        Integer unused = 5; // unused variable
    }

    public static void processSomething(String input){
        if(input != null){
            if(input.length() > 0){
                if(input.startsWith('A')){
                    System.debug('Starts with A'); // nested ifs
                }
            }
        }
    }

    public void someMethod(){
        Account a = new Account();
        a.Name = 'Test Account';
        insert a; // hardcoded value
    }

    public List<Account> getAccounts(){
        return [SELECT Id FROM Account]; // SOQL without WHERE clause
    }

    public void anotherMethod(){
        // Method does nothing
    }

}
