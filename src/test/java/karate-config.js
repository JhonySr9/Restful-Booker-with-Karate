function fn() {
  var config = {
    baseUrl: 'https://restful-booker.herokuapp.com/',
    commonHeaders: {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    }
  };
  config.faker = Java.type('com.github.javafaker.Faker');

  return config;
}