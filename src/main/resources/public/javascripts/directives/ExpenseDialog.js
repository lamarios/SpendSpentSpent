app.directive('expenseDialog', function() {
	return {
		restrict : 'E',
		scope : {
			cat : '='
		},
		templateUrl : '/javascripts/directives/ExpenseDialog.html'
	};

});