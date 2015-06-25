app.controller('HistoryController', [ '$scope', 'ExpTracker',
		function($scope, ExpTracker) {
			$scope.history = ExpTracker.history.list;
			$scope.type = function(){
				return ExpTracker.history.type;
			};
			$scope.changeType = function(type) {
				if (ExpTracker.history.type != type) {
					ExpTracker.history.type = type;
					ExpTracker.history.refresh();
				}
			}

		} ]);
