app.directive('expenseDay', function(){
	return {
  	restrict: 'E',
    scope: {
    	day: '='
    },
    templateUrl: '/assets/javascripts/directives/ExpenseDay.html'
  };

});