# RedisCF
This is a wrapper for using Redis with ColdFusion using TCP connections and not requiring any third party Java classes

## Description
This is a wrapper for using Redis with ColdFusion using TCP connections and not requiring any third party Java classes. It is a wrapper for http://redis.io/commands with the exception of get / set which can handle complex data types (structs, arrays, strings, int).  Further functions will be added as necessary. This supports the most basic functionality while being able to cache complex object types. If you wish to use the raw commands, you can use the call() method and pass the raw command.

## Author
William Giles

## License
MIT http://opensource.org/licenses/MIT

## Installation

RedisCF is installed using CFPM or can be downloaded from source

### CFPM

    cfpm add redis

## Basic Usage

In application.cfc:

    application.require = new cfpm();
    application.redis = application.require('redis');
    application.redis.setup('localhost', 6379);

Elsewhere:
    
    application.redis.set('key', 'value');
    var response = application.redis.get('key');
    writeOutput(response); // "value"
    
## Switching Databases / Multiple Commands

Redis is a single threaded application.  That means that you should not hold on to connections for any longer than necessary.  By default, RedisCF will open and close a connection for every request you make ensuring that you do not block other redis calls.  If you need to do multiple calls, such as switching databases, you need to call setup with the persitent parameter set to true.

### Example:

In application.cfc:

    application.require = new cfpm();
    application.redis = application.require('redis');

Elsewhere:
    
    application.redis.setup('localhost', 6379, true);
    application.redis.select(1);
    application.redis.set('key', 'value');
    application.redis.close();
    

    application.redis.setup('localhost', 6379, true);
    application.redis.select(1);
    var response = application.redis.get('key');
    application.redis.close();
    writeOutput(response); // "value"
    
**Because you are opening a persitent connection, it is up to you to close the connection.  If you don't close the connection, this library will not work for you**
