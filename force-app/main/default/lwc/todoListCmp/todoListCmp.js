import { LightningElement, track, wire } from 'lwc';
import getTodos from '@salesforce/apex/TodoController.getTodos';
import createTodo from '@salesforce/apex/TodoController.createTodo';
import toggleComplete from '@salesforce/apex/TodoController.toggleComplete';
import deleteTodo from '@salesforce/apex/TodoController.deleteTodo';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class TodoListCmp extends LightningElement {
    @track todos = [];
    @track newName = '';
    @track newDescription = '';

    @wire(getTodos)
    wiredTodos({ error, data }) {
        if (data) {
            this.todos = data;
        } else if (error) {
            console.error('Error loading todos:', error);
        }
    }

    handleNameChange(event) {
        this.newName = event.target.value;
    }

    handleDescriptionChange(event) {
        this.newDescription = event.target.value;
    }

    handleAddTodo() {
        if (!this.newName.trim()) {
            return;
        }

        createTodo({ name: this.newName, description: this.newDescription })
            .then(result => {
                // Add the new todo to the beginning of the list immediately
                this.todos = [result, ...this.todos];
                // Clear the input fields
                this.newName = '';
                this.newDescription = '';

                // Show success toast
                const evt = new ShowToastEvent({
                    title: 'Success',
                    message: 'Todo added successfully',
                    variant: 'success'
                });
                this.dispatchEvent(evt);
            })
            .catch(error => {
                console.error('Error creating todo:', error);

                // Show error toast
                const evt = new ShowToastEvent({
                    title: 'Error',
                    message: 'Failed to add todo',
                    variant: 'error'
                });
                this.dispatchEvent(evt);
            });
    }

    handleToggleComplete(event) {
        const todoId = event.target.dataset.id;
        const isChecked = event.target.checked;

        toggleComplete({ todoId })
            .then(result => {
                // Update the todo in the local array instead of refreshing the whole list
                const updatedTodos = this.todos.map(todo => {
                    if (todo.Id === todoId) {
                        return { ...todo, Completed__c: result.Completed__c };
                    }
                    return todo;
                });
                this.todos = updatedTodos;

                // Show toast notification
                const toastMessage = isChecked ? 'Todo marked as completed' : 'Todo marked as not completed';
                const toastVariant = isChecked ? 'success' : 'warning'; // Warning color for unchecking
                const evt = new ShowToastEvent({
                    title: 'Success',
                    message: toastMessage,
                    variant: toastVariant
                });
                this.dispatchEvent(evt);
            })
            .catch(error => {
                console.error('Error toggling todo:', error);

                // Show error toast notification
                const evt = new ShowToastEvent({
                    title: 'Error',
                    message: 'Failed to update todo status',
                    variant: 'error'
                });
                this.dispatchEvent(evt);
            });
    }

    handleDeleteTodo(event) {
        const todoId = event.target.dataset.id;
        deleteTodo({ todoId })
            .then(result => {
                // Remove the todo from the local array immediately
                this.todos = this.todos.filter(todo => todo.Id !== todoId);

                // Show success toast
                const evt = new ShowToastEvent({
                    title: 'Success',
                    message: 'Todo deleted successfully',
                    variant: 'success'
                });
                this.dispatchEvent(evt);
            })
            .catch(error => {
                console.error('Error deleting todo:', error);

                // Show error toast
                const evt = new ShowToastEvent({
                    title: 'Error',
                    message: 'Failed to delete todo',
                    variant: 'error'
                });
                this.dispatchEvent(evt);
            });
    }

    refreshTodos() {
        // Force refresh of the wired method
        const apexAction = getTodos();
        apexAction.then(data => {
            this.todos = data;
        }).catch(error => {
            console.error('Error refreshing todos:', error);
        });
    }
}
