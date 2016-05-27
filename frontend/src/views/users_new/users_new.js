'use strict';

angular.module('salesFront').controller('UsersNewCtrl', ['$scope', 'Users', function ($scope, Users) {
  $scope.newUser = {};
  $scope.registration_success_message = '';
  $scope.registration_error_message = '';

  $scope.createNewUser = function(newUser) {
    Users.createUser({user: newUser}).then(function(newUser) {
      $scope.registration_success_message = 'Registration was successfull.';
      $scope.registration_error_message = '';
    }).catch(function(error) {
      $scope.registration_error_message = 'Registration was not successfull.';
      $scope.registration_success_message = '';
    });
  };
}]);
