function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    apiUrl: 'https://conduit-api.bondaracademy.com/api/'
  }


  if (env == 'dev') {

    config.userEmail = 'dinesh@test.com'
    config.userPassword = 'dinesh12345'
    

  } else if (env == 'qa') {

    config.userEmail = 'dinesh2@test.com'
    config.userPassword = 'dinesh123456'
  }

  var accessToken = karate.callSingle('classpath:helpers/CreateToken.feature', config).authToken
  karate.configure('headers', {Authorization: 'Token ' + accessToken})

  return config;
}