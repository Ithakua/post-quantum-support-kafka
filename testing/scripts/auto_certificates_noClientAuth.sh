#!/bin/bash

# Seleccion del docker compose con autenticacion de cliente

cd ../

cp docker/docker-compose_noClientAuth.yaml ./testing/docker-compose.yaml


echo "#--------------Certification Authority Setup----------------#"

cd ./certificates

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

echo "#-----------------------------------------------------------#"


echo "#--------------Broker Setup----------------#"

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

#6. Crear la client truststore y guardar la CA:
keytool -import \
    -alias KafkaTFG-ca \
    -keystore broker/broker.truststore.pkcs12 \
    -file ca/ca.crt \
    -storepass 123456  \
    -noprompt \
    -storetype PKCS12

# 7. Guardar las credenciales de la keystore, de la trustore y de la conexión ssl:
echo "123456" > broker/broker_sslkey_creds
echo "123456" > broker/broker_keystore_creds
echo "123456" > broker/broker_truststore_creds

echo "#-----------------------------------------------------------#"


echo "#--------------Client Setup----------------#"

# # 6. Crear la broker truststore:
# keytool -genkeypair \
# -destkeystore clients/client.truststore.jks \
# -storepass 123456 \
# -alias broker-truststore \
# -keyalg RSA \
# -keysize 2048 \
# -validity 365 \
# -dname "CN=client-truststore, OU=KafkaTFG, O=UPM, L=Madrid, ST=Spain, C=Spain" \

# # 7. Guardar la CA en la truststore:
# keytool -import \
# -keystore clients/client.truststore.jks \
# -storepass 123456 \
# -alias KafkaTFG-ca \
# -file ca/ca.pem \
# -trustcacerts \
# -noprompt

#6. Crear la client truststore y guardar la CA:
keytool -import \
    -alias KafkaTFG-ca \
    -keystore clients/client.truststore.pkcs12 \
    -file ca/ca.crt \
    -storepass 123456  \
    -noprompt \
    -storetype PKCS12

# 9. Guardar las credenciales de la trustore y de la conexión:
echo "123456" > clients/client_truststore_creds
echo "123456" > clients/client_sslkey_creds

echo "#-----------------------------------------------------------#"
