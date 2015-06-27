app.controller('ExpenseController', [ '$scope', 'ExpTracker', function($scope, ExpTracker) {

	$scope.expenses = function() {
		return ExpTracker.expenses.list;
	};

	$scope.months = function() {
		return ExpTracker.expenses.months;
	};

	$scope.selectedMonth = ExpTracker.expenses.selectedMonth;

	$scope.totalIncome = function() {
		var total = 0;
		angular.forEach($scope.expenses, function(day) {
			total += day.income;
		});

		return total;
	};

	$scope.totalOutcome = function() {
		var total = 0;
		angular.forEach($scope.expenses(), function(day) {
			total += day.outcome;
		});

		return total;
	};

	$scope.changeMonth = function(month) {
		ExpTracker.expenses.selectedMonth = month;
		ExpTracker.expenses.refresh();
	};
	
	$scope.delete = function(expense){
		ExpTracker.expenses.delete(expense, function(){
			ExpTracker.history.refresh();
		});
	};
} ]);
