'use strict';

angular.module('salesFront').factory('Comments', ['$resource', '$rootScope', function Comments($resource, $rootScope) {
  var resource = $resource('/api/comments/:id', {}, {
    index: {
      method: 'GET',
      params: {
        isArray: true
      }
    },
    create: {
      method: 'POST'
    },
    destroy: {
      method: 'DELETE',
      params: {
        id: '@id'
      }
    }
  });

  return {
    getComments: function(params) {
      return resource.index(params).$promise;
    },

    createUser: function(params) {
      return resource.create(params).$promise;
    },

    destroyUser: function(params) {
      return resource.destroy(params).$promise;
    }
  };
}]);
