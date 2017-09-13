This is an API that will send encrypted messages as responses to authenticated HTTP requests. The client-side repository is [here](https://github.com/nickedwards109/secret-message-client). This README is replicated there as well.

This API will be secured with the Advanced Encryption Standard algorithm. In order for the server to respond with an HTTP 200 response, the request will need to be signed according to the following scheme:

1. The client will have access to a secret password that is practically impossible to guess, and is known to both the client and the server, but is not known to anyone else. This will probably be achieved by setting the password as a [Rails secret key](https://github.com/rails/rails/blob/7f18ea14c893cb5c9f04d4fda9661126758332b5/railties/lib/rails/tasks/misc.rake#L2) that is stored as an environment variable on the hosts of both the client-side and server-side applications. Ensuring that absolutely nobody else knows the password is outside the scope of this project.
2. The client will encrypt the request line of its HTTP GET request using AES-256-CBC and the password from step 1.
3. The client will include an Authorization header in the GET request with the value set as the string resulting from step 2. Unfortunately, we are talking about authentication, not authorization, but it seems to be a web standard to call the header 'Authorization'. See the AWS S3 docs on [Signing and Authenticating REST Requests](http://docs.aws.amazon.com/AmazonS3/latest/dev/RESTAuthentication.html), which uses a similar scheme.
4. The server will use the same password to encrypt the request line, and then compare the resulting string to the value of the Authorization header. If they match, the server will conclude that the client has authenticated properly.

This scheme ensures that the client has access to the password, and is thus the entity they say they are. It also ensures that the request has not been tampered with in transit between the client and the server.

If the client does not authenticate successfully, the server will respond with an HTTP 404 Not Found with an empty body (this provides minimal information to a potential attacker).

If the client authenticates successfully, the server will encrypt the requested data using AES-256-CBC and the same password as before. The server will set the resulting string as the body of an HTTP 200 response. The server will also sign the request using steps 1-4 above (with 'client' replaced with 'server' in those steps).

This response format ensures that an attacker who eavesdrops on the request would not be able to retrieve the secret message. It also ensures to the client that the response did indeed come from the correct server and was not tampered with during transit.

When the client receives the response and checks the signature, it will decrypt the data and render it in the browser if the signature is valid, and it will render nothing in the browser if the signature is invalid.

Check again later for more updates!
