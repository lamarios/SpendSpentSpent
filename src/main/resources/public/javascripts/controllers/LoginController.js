app.controller('LoginController', [ '$scope', 'ExpTracker', function($scope, ExpTracker) {
		$scope.username ='';
		$scope.password = '';
	
		$scope.login = function(){
			//alert($scope.username+' -> '+$scope.password);
			
			ExpTracker.session.login($scope.username, $scope.password, function(session){
				
				ExpTracker.setToken(session.token);
				$('login').hide();
			});
		};
} ]);
