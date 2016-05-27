'use strict';

angular.module('salesFront').controller('UsersLoginCtrl', ['$scope', 'Sessions', '$cookies', '$rootScope', function ($scope, Sessions, $cookies, $rootScope) {
  $scope.user = {};
  $scope.autorisation_success_message = '';
  $scope.autorisation_error_message = '';

  $scope.loginUser = function(user) {
    Sessions.createSession({user: user}).then(function(user) {
      $scope.autorisation_success_message = 'Login was successfull.';
      $scope.autorisation_error_message = '';
      $cookies.put('auth-token', user.token);
      $rootScope.authenticated = true;
    }).catch(function(error) {
      $scope.autorisation_error_message = 'Login was not successfull.';
      $scope.autorisation_success_message = '';
    });
  };
}]);
