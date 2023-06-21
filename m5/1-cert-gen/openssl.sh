#Let's create a local Certificate Authority using openssl
SUBJECT="//C=US\ST=Virginia\L=Springfield\O=None\OU=IT\CN=FibRootCA"

#Create a CA key
openssl genrsa -out ca.key.pem 4096
#Creata a CA certificate
openssl req -key ca.key.pem -new -x509 -days 7300 -sha256 -out ca.cert.pem -extensions v3_ca -subj $SUBJECT

# Create server certificate
# server cert
cat > "cert.conf" <<EOF
[ req ]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[ req_distinguished_name ]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth, serverAuth
subjectAltName = @alt_names
[ alt_names ]
DNS.1 = localhost
DNS.2 = 127.0.0.1
EOF

openssl genrsa -out localhost.key 4096

#Create the certificate from the request
openssl req -new -key localhost.key -out localhost.csr -subj "//CN=localhost\O=localhost" -config cert.conf

openssl x509 -req -days 180 -CA ca.cert.pem -CAkey ca.key.pem -CAcreateserial -in localhost.csr -out localhost.pem -extfile cert.conf -extensions v3_req