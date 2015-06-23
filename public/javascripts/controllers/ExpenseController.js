app.controller('ExpenseController', [ '$scope', 'ExpTracker',
		function($scope, ExpTracker) {

			$scope.expenses = ExpTracker.expenses.list;
			$scope.months = ExpTracker.expenses.months;
			$scope.selectedMonth = ExpTracker.expenses.selectedMonth;

			$scope.totalIncome = function() {
				var total = 0;
				angular.forEach($scope.expenses, function(day, key) {
					total += day.income;
				});

				return total;
			};

			$scope.totalOutcome = function() {
				var total = 0;
				angular.forEach($scope.expenses, function(day, key) {
					total += day.outcome;
				});

				return total;
			}
			
			$scope.changeMonth = function(month){
				ExpTracker.expenses.selectedMonth = month;
				ExpTracker.expenses.refresh();
			}
		} ]);
