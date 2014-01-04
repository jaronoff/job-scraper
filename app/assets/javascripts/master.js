angular.module("Clss", [])

.controller('JobsCtrl', function($scope, $http) {
  $scope.jobs = {};

  $scope.working = "";

  $scope.getJobs = function(search_term) {
    $http.get('/jobs/' + encodeURIComponent(search_term)).
    success(function(data, status) {
      $scope.working = "Working!"
      $scope.jobs = JSON.parse(data)
    }).
    error(function(data, status) {

        console.log("Something went wrong " + status);
    });
    alert("works")
  }
})