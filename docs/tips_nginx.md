
### Install

    brew install nginx



### Config

##### 1. vim /usr/local/etc/nginx/servers/http_9092.conf


    server{
    
        listen       9092;
        server_name  10.194.1.2;
    
        location / {
            root   __path_to_document__/Nginx/;
            index  index.html index.htm;
            autoindex  on;
        }
    
    }

##### 2. vim /usr/local/etc/nginx/servers/https_9090.conf


    server{
    
        listen       9090 ssl;
        server_name  10.194.1.2;
    
        ssl_certificate      __path_to_document__/Nginx/caOfPP/ca.crt;
        ssl_certificate_key  __path_to_document__/Nginx/caOfPP/ca.key;
        ssl_protocols  TLSv1.3;
    
        location / {
            root   __path_to_document__/Nginx/;
            index  index.html index.htm;
            autoindex  on;
        }
    
    }


##### 3. One sample of openssl.cnf

    [ ca ]
    default_ca			= CA_default		# The default ca section
    
    [ CA_default ]
    dir		= .
    new_certs_dir		= $dir/newcerts				# default place for new certs
    database			= $dir/newcerts/index.txt	# database index file
    policy				= policy_match
    serial				= $dir/newcerts/serial 		# The current serial number
    default_md			= sha256					# use SHA-256 by default
    default_bits		= 2048
    
    [ policy_match ]
    countryName				= match
    stateOrProvinceName		= match
    organizationName		= AiMei
    organizationalUnitName	= AiMei
    commonName				= supplied
    emailAddress			= handsomeman@aimei.com
    
    [ req_ext ]
    subjectAltName 			= @alt_names
    
    
    [ alt_names ]
    IP.1 = 127.0.0.1
    IP.2 = 10.192.160.1
    IP.3 = 10.194.1.1
    DNS.1 = localhost
    
    
    [ req ]
    #default_bits		= 2048
    #default_md		= sha256
    #default_keyfile 	= privkey.pem
    distinguished_name	= req_distinguished_name
    attributes		= req_attributes
    
    [ req_distinguished_name ]
    countryName			= Country Name (2 letter code)
    countryName_min			= 2
    countryName_max			= 2
    stateOrProvinceName		= State or Province Name (full name)
    localityName			= Locality Name (eg, city)
    0.organizationName		= Organization Name (eg, company)
    organizationalUnitName		= Organizational Unit Name (eg, section)
    commonName			= Common Name (eg, fully qualified host name)
    commonName_max			= 64
    emailAddress			= Email Address
    emailAddress_max		= 64
    subjectAltName 			= @alt_names
    
    [ req_attributes ]
    challengePassword		= A challenge password
    challengePassword_min		= 4
    challengePassword_max		= 20