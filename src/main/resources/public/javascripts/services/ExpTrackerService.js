

app.factory('ExpTracker', [ '$http', function($http) {

	var categoryService = CategoryService($http);
	var expenseService = ExpenseService($http);
	var historyService = HistoryService($http);
	var recurringService = RecurringExpenseService($http);
	var settingsService = SettingsService($http);
	var sessionService = SessionService($http);

	service = {
		categories : categoryService,
		expenses : expenseService,
		history : historyService,
		recurring : recurringService,
		settings : settingsService,
		session : sessionService,
		token : ''
	};

	service.setToken = function(token) {
		service.token = token;
		
		$http.defaults.headers.common.Authorization = token;
		service.refresh();
		if (typeof (Storage) !== "undefined") {
			localStorage.setItem("token", token);
		}
	};

	service.refresh = function() {
		expenseService.refreshMonths();
		categoryService.refresh();
		categoryService.refreshAvailableIcons();
		historyService.refresh();
		recurringService.refresh();
		settingsService.refresh();
	};

	if (typeof (Storage) !== "undefined") {
		var token = localStorage.getItem("token");
		if (token !== undefined && token !== '' && token !== null && token !== 'undefined') {
			service.setToken(token);
		}else{
			service.refresh();
		}
	}

	return service;

} ]);
