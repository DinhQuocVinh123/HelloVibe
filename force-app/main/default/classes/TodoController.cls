public with sharing class TodoController {
    @AuraEnabled(cacheable=true)
    public static List<Todo__c> getTodos() {
        try {
            //I simply just add a new comment
            //I put another comment
            //I put another comment
            //I put another comment
            // Simple query for all Todo__c records
            List<Todo__c> records = [SELECT Id, Name, Description__c, Completed__c, CreatedDate, LastModifiedDate, OwnerId FROM Todo__c ORDER BY CreatedDate DESC]
            return records;
        } catch (Exception e) {
            throw new AuraHandledException('Failed to get todos: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static Todo__c createTodo(String name, String description) {
        try {
            // Validate required fields
            if (name == null || name.trim().length() == 0) {
                throw new AuraHandledException('Name is required.');
            }

            // Create new Todo__c record
            Todo__c t = new Todo__c();
            t.Name = name;
            if (description != null) t.Description__c = description;

            // Insert the record
            Database.SaveResult sr = Database.insert(t, true);
            if (!sr.isSuccess()) {
                throw new AuraHandledException('Insert failed: ' + collectErrors(sr));
            }

            // Return the inserted record
            Todo__c created = [SELECT Id, Name, Description__c, Completed__c, CreatedDate, LastModifiedDate, OwnerId FROM Todo__c WHERE Id = :sr.getId()];
            return created;
        } catch (Exception e) {
            throw new AuraHandledException('Failed to create todo: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static Todo__c toggleComplete(Id todoId) {
        try {
            if (todoId == null) {
                throw new AuraHandledException('todoId is required.');
            }

            // Query the record to update
            Todo__c t = [SELECT Id, Completed__c FROM Todo__c WHERE Id = :todoId LIMIT 1];
            t.Completed__c = !Boolean.valueOf(t.Completed__c);

            // Update the record
            Database.SaveResult sr = Database.update(t, true);
            if (!sr.isSuccess()) {
                throw new AuraHandledException('Update failed: ' + collectErrors(sr));
            }

            // Return the updated record
            Todo__c updated = [SELECT Id, Name, Description__c, Completed__c, CreatedDate, LastModifiedDate, OwnerId FROM Todo__c WHERE Id = :todoId];
            return updated;
        } catch (Exception e) {
            throw new AuraHandledException('Failed to toggle todo: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static Boolean deleteTodo(Id todoId) {
        try {
            if (todoId == null) {
                throw new AuraHandledException('todoId is required.');
            }

            // Delete the record
            Database.DeleteResult dr = Database.delete(new List<Id>{ todoId }, true)[0];
            if (!dr.isSuccess()) {
                throw new AuraHandledException('Delete failed: ' + collectErrors(dr));
            }
            return true;
        } catch (Exception e) {
            throw new AuraHandledException('Failed to delete todo: ' + e.getMessage());
        }
    }

    @TestVisible
    // Helper to collect DML errors
    private static String collectErrors(Database.SaveResult sr) {
        List<String> msgs = new List<String>();
        for (Database.Error err : sr.getErrors()) {
            msgs.add(err.getMessage());
        }
        return String.join(msgs, '; ');
    }
    @TestVisible
    private static String collectErrors(Database.DeleteResult dr) {
        List<String> msgs = new List<String>();
        for (Database.Error err : dr.getErrors()) {
            msgs.add(err.getMessage());
        }
        return String.join(msgs, '; ');
    }
}