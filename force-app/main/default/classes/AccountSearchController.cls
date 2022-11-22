// The with sharing keyword enforces the sharing rules that apply to the current user when this Apex class works with records.
// The @AuraEnabled annotation exposes this method to your Lightning components.
// The List<List<SObject>> searchResults holds the SOSL query results.
// The FIND :searchTerm specifies what text to search for in account fields.
// The RETURNING Account clause specifies which account fields to return and how to order the results.
public with sharing class AccountSearchController {
    @AuraEnabled
    public static List<Account> searchAccounts( String searchTerm ) {
        List<Account> accounts = new List<Account>();
        String searchWildCard = '*' + searchTerm + '*';
        if ( String.isNotBlank( searchTerm ) && searchTerm.length() > 1 ) {
            List<List<SObject>> searchResults = [
                FIND :searchWildCard
                RETURNING Account(
                    Id, Name, Phone, Website,
                    BillingStreet, BillingCity,
                    BillingState, BillingPostalCode
                    ORDER BY Name
                    LIMIT 10
                )
            ];
            accounts = searchResults[0];
        }
        return accounts;
    }
}