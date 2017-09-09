function RecurringExpenseService($http){
	var recurringService = {};
	recurringService.list = [];
	
	
	recurringService.refresh = function(callback){
		console.log('GET /API/RecurringExpense');
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
		console.log('PUT /API/RecurringExpense');
		$http.post('/API/RecurringExpense', newExpense, HTTP_HEADERS).success(function(data) {
			console.log(data);
			recurringService.list.push(data);
			if (callBack !== undefined) {
				callBack(data);
			}
		});
	};

	recurringService.delete = function(recurring, callback){
		console.log('DELETE /API/RecurringExpense/'+recurring.id);
		$http.delete('/API/RecurringExpense/'+recurring.id).success(function(data){
			
			//recurringService.refresh();
			var index = recurringService.list.indexOf(recurring);
			recurringService.list.splice(index, 1);
			
			if(callback !== undefined){
				callback(data);
			}
		});
	};
	
	return recurringService;
}