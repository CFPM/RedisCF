# RedisCF
This is a wrapper for using Redis with ColdFusion using TCP connections and not requiring any third party Java classes

##Description
This is a wrapper for using Redis with ColdFusion using TCP connections and not requiring any third party Java classes. It is a wrapper for http://redis.io/commands with the exception of get / set which can handle complex data types (structs, arrays, strings, int).  Further functions will be added as necessary. This supports the most basic functionality while being able to cache complex object types. If you wish to use the raw commands, you can use the call() method and pass the raw command.

##Author
William Giles

##License
MIT http://opensource.org/licenses/MIT

##Installation

Micro CF is installed using CFPM or can be downloaded from source

###CFPM

    python cfpm.py require redis

##Basic Usage

In application.cfc:

    application.require = new cfpm();
    application.redis = application.require('redis');
    application.redis.setup('localhost', 6379, true);

Elsewhere:

    application.redis.set('key', 'value');
    var response = application.redis.get('key');
    writeOutput(response); // "value"