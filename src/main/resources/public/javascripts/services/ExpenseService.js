function ExpenseService($http) {
	var expenseService = {};

	expenseService.list = [];
	expenseService.months = [];
	expenseService.selectedMonth = "";

	// Add expense
	expenseService.add = function(newExpense, callBack) {
		console.log('POST /API/Expense');
		$http.post('/API/Expense', newExpense, HTTP_HEADERS).success(function(expense) {

			expenseService.refreshMonths();
			if (callBack !== undefined) {
				callBack(expense);
			}
		});
	};

	// Refresh expense based on the selected month
	expenseService.refresh = function(callback) {
		// while (expenseService.list.length > 0) {
		// expenseService.list.pop();
		// }

		console.log('GET /API/Expense/ByDay?month=' + expenseService.selectedMonth);
		$http.get('/API/Expense/ByDay?month=' + expenseService.selectedMonth).success(function(data) {
			console.log(data);
			// angular.forEach(data, function(value, index) {
			// expenseService.list.push(value);
			// });
			expenseService.list = data;

			if (callback !== undefined) {
				callback();
			}
		}).error(function(err) {
			return err;
		});
	};

	expenseService.refreshMonths = function() {

		console.log('GET /API/Expense/GetMonths');
		// getting all the months available
		$http.get('/API/Expense/GetMonths').success(function(data) {
			console.log(data);
			expenseService.months = data;

			// refreshing the current expenses to of the
			// selected month
			if (expenseService.selectedMonth === "") {
				expenseService.selectedMonth = expenseService.months[expenseService.months.length - 1];
				console.log("Selected Month:" + expenseService.selectedMonth);
			}

			expenseService.refresh();
		}).error(function(err) {
			return err;
		});
	};
	
	expenseService.delete = function(expense, callback){
		console.log('DELETE /API/Expense/'+expense.id);
		
		$http.delete('/API/Expense/'+expense.id).success(function(data){
			
			expenseService.refresh();
			
			if(callback !== undefined){
				callback(data);
			}
		});
		
	};

	return expenseService;
}