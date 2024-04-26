#!/bin/bash


# Seleccion del docker compose con autenticacion de cliente

cd ../

cp ./docker/docker-compose_clientAuth.yaml ./testing/docker-compose.yaml


echo "#--------------Certification Authority Setup----------------#"

cd ./certificates

# 0. Se generan la CA utilizando DIlithium3

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

echo "#--------------Firmar los certificados con la CA----------------#"

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

echo "#--------------Convertir el certificado del servidor a formato pkcs12:----------------#"

# 4. Convertir el certificado del servidor a formato pkcs12:
openssl pkcs12 -export \
-in broker/broker.crt \
-inkey broker/broker.key \
-chain \
-CAfile ca/ca.pem \
-name broker \
-out broker/broker.p12 \
-password pass:123456

echo "#--------------Crear la broker keystore:----------------#"


# 5. Crear la broker keystore:
keytool -importkeystore \
-deststorepass 123456 \
-destkeystore broker/broker.keystore.pkcs12 \
-srckeystore broker/broker.p12 \
-deststoretype PKCS12  \
-srcstoretype PKCS12 \
-noprompt \
-srcstorepass 123456

# # 5. PQC Option:
# keytool -genkeypair \
# -alias your_alias \
# -storetype pkcs12 \
# -keyalg DILITHIUM3 \
# -sigalg DILITHIUM3 \
# -keystore broker.keystore.pkcs12 \ 
# -validity 365 \
# -storepass 123456 \ 
# -keypass 123456 \
# -provider org.bouncycastle.jce.provider.BouncyCastleProvider \
# -providerpath ../../docker/libs/BouncyCustomProvider.jar 

echo "#--------------Crear la client truststore y guardar la CA:----------------#"

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