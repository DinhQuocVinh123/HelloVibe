@IsTest
private class TodoControllerTest {

    // 🧩 Helper method tạo Todo mẫu
    private static Todo__c createSampleTodo(String name, String descriptionText, Boolean completed) {
        Todo__c t = new Todo__c(
            Name = name,
            Description__c = descriptionText,
            Completed__c = completed
        );
        insert t;
        return t;
    }

    // ✅ Test tạo mới thành công
    @IsTest
    static void test_createTodo_success() {
        Test.startTest();
        Todo__c created = TodoController.createTodo('Test Todo', 'This is a description');
        Test.stopTest();

        System.assertNotEquals(null, created.Id, 'Todo must be created');
        System.assertEquals('Test Todo', created.Name);
        System.assertEquals('This is a description', created.Description__c);
        System.assertEquals(false, created.Completed__c);
    }

    // ⚠️ Test lỗi thiếu Name
    @IsTest
    static void test_createTodo_missingName_shouldThrowError() {
        try {
            Test.startTest();
            TodoController.createTodo('', 'Description');
            Test.stopTest();
            System.assert(false, 'Expected AuraHandledException for missing name');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains('Failed to create todo: Name is required'), e.getMessage());
        }
    }

    // ✅ Test truy vấn getTodos()
    @IsTest
    static void test_getTodos_returnsList() {
        createSampleTodo('Todo 1', 'Desc 1', false);
        createSampleTodo('Todo 2', 'Desc 2', true);

        Test.startTest();
        List<Todo__c> todos = TodoController.getTodos();
        Test.stopTest();

        System.assert(todos.size() >= 2, 'Should return at least 2 todos');
        System.assertNotEquals(null, todos[0].CreatedDate);
    }

    // ✅ Test toggleComplete thành công
    @IsTest
    static void test_toggleComplete_success() {
        Todo__c t = createSampleTodo('Toggle Todo', 'To test toggle', false);

        Test.startTest();
        Todo__c updated = TodoController.toggleComplete(t.Id);
        Test.stopTest();

        System.assertEquals(true, updated.Completed__c, 'Todo should be toggled to true');
    }

    // ⚠️ Test toggleComplete lỗi null Id
    @IsTest
    static void test_toggleComplete_withNullId_shouldThrowError() {
        try {
            Test.startTest();
            TodoController.toggleComplete(null);
            Test.stopTest();
            System.assert(false, 'Expected AuraHandledException');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains('Failed to toggle todo: todoId is required'), e.getMessage());
        }
    }

    // ✅ Test deleteTodo thành công
    @IsTest
    static void test_deleteTodo_success() {
        Todo__c t = createSampleTodo('Delete Me', 'Temporary', false);

        Test.startTest();
        Boolean result = TodoController.deleteTodo(t.Id);
        Test.stopTest();

        System.assertEquals(true, result, 'Delete should return true');
        System.assertEquals(0, [SELECT COUNT() FROM Todo__c WHERE Id = :t.Id], 'Record should be deleted');
    }

    // ⚠️ Test deleteTodo lỗi null Id
    @IsTest
    static void test_deleteTodo_withNullId_shouldThrowError() {
        try {
            Test.startTest();
            TodoController.deleteTodo(null);
            Test.stopTest();
            System.assert(false, 'Expected AuraHandledException');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains('Failed to delete todo: todoId is required'), e.getMessage());
        }
    }

    // 🧩 Test trực tiếp 2 hàm collectErrors()
    @IsTest
    static void test_collectErrors_direct() {
        Database.SaveResult sr = (Database.SaveResult) JSON.deserialize(
            '{"success": false, "errors": [{"message": "Fake insert error"}]}',
            Database.SaveResult.class
        );
        Database.DeleteResult dr = (Database.DeleteResult) JSON.deserialize(
            '{"success": false, "errors": [{"message": "Fake delete error"}]}',
            Database.DeleteResult.class
        );

        String msg1 = TodoController.collectErrors(sr);
        String msg2 = TodoController.collectErrors(dr);

        System.assert(msg1.contains('Fake insert error'));
        System.assert(msg2.contains('Fake delete error'));
    }
}