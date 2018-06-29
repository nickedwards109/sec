This is a server-side application that securely serves up secret messages to an authenticated client. The client-side repository is [here](https://github.com/nickedwards109/secure-client).

In this context, 'securely' means that the client authenticates each HTTP request, and the server encrypts and authenticates each response. This scheme ensures that only an authenticated client can access data on the server. It also ensures that an eavesdropper on the wire cannot intercept the HTTP response and access the requested data. It also allows the client to verify the integrity of the data it receives, ensuring that an attacker cannot intercept the HTTP response and modify the data unknown to the client.

A successful HTTP request and response depends on the client and server both having access to the same secret key. The process looks like this:

*Client sends a request*  
1. The client generates a digital signature by hashing the request line of its HTTP GET request using SHA-256 and the secret key. This digital signature can also be referred to as a Hash-Based Message Authentication Code, or HMAC.  
2. The client includes an Authorization header in the GET request with the value set as the HMAC from step 1.  

*Server processes the request*  
3. The server uses the secret key to generate an HMAC from the request line, and then compares the resulting HMAC to the value of the request's Authorization header. If they match, the server concludes that the client has authenticated properly.  

*Server sends a response*  
4. The server encrypts the requested data using AES-256-CBC and the secret key.  
5. The server sets the resulting string as the body of an HTTP 200 response.  
6. The server generates an HMAC by hashing the requested data using SHA-256 and the secret key.  
7. The server includes an Authorization header in the HTTP response with the value set as the HMAC from step 6.  

*Client processes the response*  
8. The client receives the 200 response and decrypts the response body using the secret key.  
9. The client uses the secret key to generate an HMAC from the unencrypted response body. The client compares this HMAC to the value of the response's Authorization header. If they match, the client concludes that the response was not tampered with in transit.  
10. The client renders the message in the browser.  
