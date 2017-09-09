app.directive('expenseDay', function() {
	return {
		restrict : 'E',
		scope : {
			day : '='
		},
		templateUrl : '/javascripts/directives/ExpenseDay.html'
	};

});