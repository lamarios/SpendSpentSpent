app.factory('ExpTracker', [ '$http', function($http) {

	var categoryService = CategoryService($http);
	var expenseService = ExpenseService($http);
	var historyService = HistoryService($http);


	expenseService.refreshMonths();
	categoryService.refresh();
	categoryService.refreshAvailableIcons();
	historyService.refresh();
	
	service = {
		categories : categoryService,
		expenses : expenseService,
		history: historyService
	};

	return service;

} ]);
