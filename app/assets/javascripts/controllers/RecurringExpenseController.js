app.controller('ReucurringExpenseController', [ '$scope', 'ExpTracker', function($scope, ExpTracker) {

	$scope.expenses = function() {
		return ExpTracker.recurring.list;
	};

	$scope.categories = function() {
		return ExpTracker.categories.list;
	};
	
	$scope.selected = null;
	$scope.showDialog = false;

	$scope.newExpenseAmount = '';
	$scope.typeParam = 0;
		
	$scope.addExpense = function(selected, newExpenseAmount, type, typeParam){
		var newExpense = {
			amount: newExpenseAmount,
			category: selected,
			type: type,
			typeParam: typeParam,
			name:''
		};
		
		console.log(newExpense);
		
		ExpTracker.recurring.add(newExpense, function(){
			$scope.showDialog = false;
		});
	};
	
	
	$scope.addNewExpenseDigit = function(digit) {

		var newAmount = $scope.newExpenseAmount + digit;

		var patt = new RegExp(/^[0-9]+(\.[0-9]{0,2})?$/);

		if (patt.test(newAmount)) {
			$scope.newExpenseAmount = newAmount;
		}
		// $scope.newExpenseAmount+=digit;
	};

	$scope.removeNewExpenseDigit = function() {
		$scope.newExpenseAmount = $scope.newExpenseAmount.substring(0,
				$scope.newExpenseAmount.length - 1);
	};
	
	$scope.deleteRecurring = function(recurring){
		ExpTracker.recurring.delete(recurring);
	};
	
	$scope.closeDialog = function(){
		$scope.showDialog = false;
	};
	
	$scope.changeParam = function(param){
		$scope.typeParam = param;
	};
	
} ]);
