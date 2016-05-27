'use strict';

angular.module('salesFront').factory('Transactions', ['$resource', '$rootScope', function Transactions($resource, $rootScope) {
  var resource = $resource('/api/transactions/:id', {}, {
    index: {
      method: 'GET',
      params: {
        isArray: true
      }
    }
  });

  return {
    getTransactions: function(params) {
      return resource.index(params).$promise;
    }
  };
}]);
