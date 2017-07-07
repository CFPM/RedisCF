/*
 * Any changes should be made and pushed to here: https://github.com/Prefinem/RedisCF
 * Author: William Giles
 * License: MIT http://opensource.org/licenses/MIT
 */

component {

	function setup (string host = 'localhost', numeric port = '6379', boolean persistant = false) {
		this.host = arguments.host;
		this.port = arguments.port;
		this.persistant = arguments.persistant;

		if (this.persistant) {
			createSocket();
			if (this.socket.isConnected()) {
				createOutput();
				createInput();
			} else {
				throw("Failed to connect to Redis");
			}
		}
	}

	public function onMissingMethod (MissingMethodName, MissingMethodArguments) {
		var command = uCase(Replace(MissingMethodName, '_', ' ', 'all'));

		command = command & ' ' & ArrayToList(MissingMethodArguments, ' ');

		return call(command);
	}

	public function set (string key, any value, string expiration='') {
		value = encode(value);

		var command = 'SET #key# #value# #expiration#';

		call(command);
	}

	public function get (string key) {
		var command = 'GET #key#';
		var result = call(command);

		if (trim(result) != '') {
			result = decode(result);
		}

		return result;
	}

	public function close () {
		this.socket.close();
	}

	public function call (required string command) {
		if (this.persistant) {
			return run(command);
		}

		createSocket();

		if (this.socket.isConnected()) {
			createOutput();
			createInput();
			var result = run(command);
			closeSocket();
			if (!IsNull(result)) {
				return result;
			}
		}

		return '';
	}


	private function run (required string command) {
		this.output.println(arguments.command);
		this.output.println();
		this.output.flush();

		var result = this.input.readLine();

		if (Left(result, 1) == '$') { // http://redis.io/topics/protocol#resp-bulk-strings
			var length = Replace(result, '$', '');
			if (length > 0) {
				return this.input.readLine();
			}
		}

		return '';
	}

	private function createSocket () {
		this.socket = createObject("java", "java.net.Socket");

		try{
			this.socket.init(this.host, this.port);
		}catch(java.net.ConnectException error) {
			throw(message="#error.Message#: Could not connected to host #this.host# on port #this.port#");
		}
	}

	private function createOutput () {
		var outputStream = this.socket.getOutputStream();
		this.output = createObject("java", "java.io.PrintWriter").init(outputStream);
	}

	private function createInput () {
		var inputStream = this.socket.getInputStream();
		var inputStreamReader = createObject("java", "java.io.InputStreamReader").init(inputStream);

		this.input = createObject("java", "java.io.BufferedReader").init(inputStreamReader);
	}

	private function closeSocket () {
		if (this.socket.isConnected()) {
			this.socket.close();
		}
	}

	private function encode (value) {
		if (IsValid('component', value)) {
			throw(message='Can not encode component');
		}

		return BinaryEncode(ObjectSave(SerializeJSON(value)), 'Base64');
	}

	private function decode (value) {
		var temp = ObjectLoad(BinaryDecode(value, 'Base64'));

		if (IsValid('string', temp)) {
			return DeserializeJSON(temp, false);
		}

		return temp;
	}
}