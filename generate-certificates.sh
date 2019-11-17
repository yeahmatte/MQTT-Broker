# ========= CA =============
# Generate a certificate authority (CA) key.
openssl genrsa -des3 -out ./Certificates/output/ca.key 2048
#Generate a certificate authority (CA) certificate.
openssl req -new -x509 -key ./Certificates/output/ca.key -out ./Certificates/output/ca.crt -config ./Certificates/confs/ca.conf
#Check certificate authority (CA) certificate.
openssl x509 -in ./Certificates/output/ca.crt -noout -text

# ======= SERVER ==========
#Generate a server key without encryption.
openssl genrsa -out ./Certificates/output/server.key 2048
#Create a certificate request.
openssl req -new -out ./Certificates/output/server.csr -key ./Certificates/output/server.key -config ./Certificates/confs/server.conf
#Verify CSR file.
openssl req -noout -text -in ./Certificates/output/server.csr
#Generate server certificate.
openssl x509 -req -in ./Certificates/output/server.csr -CA ./Certificates/output/ca.crt -CAkey ./Certificates/output/ca.key -CAcreateserial -out ./Certificates/output/server.crt
#Check server certificate.
openssl x509 -in ./Certificates/output/server.crt -noout -text
#Verify server certificate.
#Verify that a server certificate is signed by a particular CA.
openssl verify -CAfile ./Certificates/output/ca.crt ./Certificates/output/server.crt

# ======= CLIENT ===========
#Generate a client key.
#openssl genrsa -des3 -out client.key 2048
openssl genrsa -out ./Certificates/output/client.key 2048
#Generate a certificate signing request to send to the CA.
openssl req -out ./Certificates/output/client.csr -key ./Certificates/output/client.key -new -config ./Certificates/confs/client.conf
#Send the CSR to the CA, or sign it with your CA key:
openssl x509 -req -in ./Certificates/output/client.csr -CA ./Certificates/output/ca.crt -CAkey ./Certificates/output/ca.key -CAcreateserial -out ./Certificates/output/client.crt -addtrust clientAuth
#Check client certificate.
openssl x509 -in ./Certificates/output/client.crt -noout -text
#Verify that a server certificate is signed by a particular CA.
openssl verify -CAfile ./Certificates/output/ca.crt ./Certificates/output/client.crt
