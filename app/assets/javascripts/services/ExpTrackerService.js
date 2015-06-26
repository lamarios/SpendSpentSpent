app.factory('ExpTracker', [ '$http', function($http) {

	var categoryService = CategoryService($http);
	var expenseService = ExpenseService($http);
	var historyService = HistoryService($http);
	var recurringService = RecurringExpenseService($http);

	expenseService.refreshMonths();
	categoryService.refresh();
	categoryService.refreshAvailableIcons();
	historyService.refresh();
	recurringService.refresh();
	
	service = {
		categories : categoryService,
		expenses : expenseService,
		history: historyService,
		recurring: recurringService
	};

	return service;

} ]);
