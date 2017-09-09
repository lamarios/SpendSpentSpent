app.controller('SettingsController', [ '$scope', 'ExpTracker', '$rootScope', function($scope, ExpTracker, $rootScope) {
	$scope.authentication = false;
	$scope.username = '';
	$scope.password = '';
	$scope.pushbullet = false;
	$scope.pushalot = false;
	$scope.pushalotApi = '';
	$scope.pushbulletApi = '';
	$scope.pushover = false;
	$scope.pushoverAppToken = '';
	$scope.pushoverUserToken = '';
	$scope.windowsTile = false;
	$scope.googlemap = '';

	ExpTracker.settings.refresh(function(settings) {
		if (settings.authentication !== undefined)
			$scope.authentication = settings.authentication.value === "true";
		if (settings.username !== undefined)
			$scope.username = settings.username.value;
		if (settings.pushbullet !== undefined)
			$scope.pushbullet = settings.pushbullet.value === "true";
		if (settings.pushbulletApi !== undefined)
			$scope.pushbulletApi = settings.pushbulletApi.value;
		if (settings.pushalot !== undefined)
			$scope.pushalot = settings.pushalot.value === "true";
		if (settings.pushalotApi !== undefined)
			$scope.pushalotApi = settings.pushalotApi.value;
		if (settings.pushover !== undefined)
			$scope.pushover = settings.pushover.value === "true";
		if (settings.pushoverAppToken !== undefined)
			$scope.pushoverAppToken = settings.pushoverAppToken.value;
		if (settings.pushoverUserToken !== undefined)
			$scope.pushoverUserToken = settings.pushoverUserToken.value;
		if (settings.windowsTile !== undefined)
			$scope.windowsTile = settings.windowsTile.value === "true";
		if (settings.googlemap !== undefined)
			$scope.googlemap = settings.googlemap.value;
	});

	$scope.saveSettings = function() {
		var setting = {
			name : 'authentication',
			value : $scope.authentication
		};
		ExpTracker.settings.update(setting);

		if ($scope.authentication) {
			setting = {
				name : 'username',
				value : $scope.username
			};
			ExpTracker.settings.update(setting, function() {
				setting = {
					name : 'password',
					value : $scope.password
				};
				ExpTracker.settings.update(setting);
			});
		}
		setting = {
			name : 'pushbullet',
			value : $scope.pushbullet
		};
		ExpTracker.settings.update(setting);

		setting = {
			name : 'pushbulletApi',
			value : $scope.pushbulletApi
		};
		ExpTracker.settings.update(setting);

		setting = {
			name : 'pushalot',
			value : $scope.pushalot
		};
		ExpTracker.settings.update(setting);

		setting = {
			name : 'pushalotApi',
			value : $scope.pushalotApi
		};
		ExpTracker.settings.update(setting);

		setting = {
			name : 'pushover',
			value : $scope.pushover
		};
		ExpTracker.settings.update(setting);

		setting = {
			name : 'pushoverAppToken',
			value : $scope.pushoverAppToken
		};
		ExpTracker.settings.update(setting);

		setting = {
			name : 'pushoverUserToken',
			value : $scope.pushoverUserToken
		};
		ExpTracker.settings.update(setting);

		setting = {
			name : 'windowsTile',
			value : $scope.windowsTile
		};
		ExpTracker.settings.update(setting);

		$scope.closeDialog();
		
		setting = {
			name : 'googlemap',
			value : $scope.googlemap
		};
		ExpTracker.settings.update(setting);

		$scope.closeDialog();
				
			
	};

	$scope.closeDialog = function() {
		$rootScope.showSettings = false;
	};

} ]);
