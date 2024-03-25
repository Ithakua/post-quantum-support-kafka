#!/bin/bash

cd ../certificates

#--------------Certification Authority Setup----------------#

# 0. Generar la Certification Authority basada en un .cnf:
openssl req -new -nodes \
   -x509 \
   -days 365 \
   -newkey rsa:2048 \
   -keyout ca/ca.key \
   -out ca/ca.crt \
   -config ca/ca.cnf

# 1. Convertir el ca.key a ca.pem:	
cat ca/ca.crt ca/ca.key > ca/ca.pem

#-----------------------------------------------------------#


#--------------Broker Setup----------------#

# 2. Crear el certificado y la key del broker:
openssl req -new \
-newkey rsa:2048 \
-keyout broker/broker.key \
-out broker/broker.csr \
-config broker/broker.cnf \
-nodes


# 3. Firmar los certificados con la CA:
openssl x509 -req \
-days 3650 \
-in broker/broker.csr \
-CA ca/ca.crt \
-CAkey ca/ca.key \
-CAcreateserial \
-out broker/broker.crt \
-extfile broker/broker.cnf \
-extensions req_v3

# 4. Convertir el certificado del servidor a formato pkcs12:
openssl pkcs12 -export \
-in broker/broker.crt \
-inkey broker/broker.key \
-chain \
-CAfile ca/ca.pem \
-name broker \
-out broker/broker.p12 \
-password pass:123456

# 5. Crear la broker keystore:
keytool -importkeystore \
-deststorepass 123456 \
-destkeystore broker/broker.keystore.pkcs12 \
-srckeystore broker/broker.p12 \
-deststoretype PKCS12  \
-srcstoretype PKCS12 \
-noprompt \
-srcstorepass 123456

# 6. Crear la broker truststore:
keytool -genkeypair \
-destkeystore broker/broker.truststore.jks \
-storepass 123456 \
-alias broker-truststore \
-keyalg RSA \
-keysize 2048 \
-validity 365 \
-dname "CN=broker-truststore, OU=KafkaTFG, O=UPM, L=Madrid, ST=Spain, C=Spain" \

# 7. Guardar la CA en la truststore:
keytool -import \
-keystore broker/broker.truststore.jks \
-storepass 123456 \
-alias KafkaTFG-ca \
-file ca/ca.pem \
-trustcacerts \
-noprompt


# 8. Guardar las credenciales de la keystore, de la trustore y de la conexión ssl:
echo "123456" > broker/broker_sslkey_creds
echo "123456" > broker/broker_keystore_creds
echo "123456" > broker/broker_truststore_creds

#-----------------------------------------------------------#
