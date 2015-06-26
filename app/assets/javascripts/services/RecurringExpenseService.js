function RecurringExpenseService($http){
	var recurringService = {};
	recurringService.list = [];
	
	
	recurringService.refresh = function(callback){
		console.log('Calling /API/RecurringExpense');
		$http.get('/API/RecurringExpense').success(function(data){
			recurringService.list = data;
			console.log(data);
			if(callback !== undefined){
				callback(data);
			}
		});
	};
	
	
	// Add expense
	recurringService.add = function(newExpense, callBack) {
		console.log('Calling /API/RecurringExpense');
		$http.post('/API/RecurringExpense', newExpense, HTTP_HEADERS).success(function(data) {
			console.log(data);
			recurringService.list.push(data);
			if (callBack !== undefined) {
				callBack(data);
			}
		});
	};

	
	return recurringService;
}