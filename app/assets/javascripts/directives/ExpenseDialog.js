app.directive('expenseDialog', function() {
	return {
		restrict : 'E',
		scope : {
			cat : '='
		},
		templateUrl : '/assets/javascripts/directives/ExpenseDialog.html'
	};

});