'use strict';

angular.module('salesFront').factory('Deals', ['$resource', '$rootScope', function Deals($resource, $rootScope) {
  var resource = $resource('/api/deals/:id', {}, {
    index: {
      method: 'GET',
      params: {
        isArray: true
      }
    },
    show: {
      method: 'GET',
      params: {
        id: '@id'
      }
    },
    create: {
      method: 'POST'
    }
  });

  return {
    getDeals: function(params) {
      return resource.index(params).$promise;
    },

    getDeal: function(params) {
      return resource.show(params).$promise;
    },

    createDeal: function(params) {
      return resource.create(params).$promise;
    }
  };
}]);
