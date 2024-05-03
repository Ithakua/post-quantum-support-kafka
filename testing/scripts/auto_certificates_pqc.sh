#!/bin/bash


# Seleccion del docker compose con autenticacion de cliente

cd ../

cp ./docker/docker-compose_clientAuth.yaml ./testing/docker-compose.yaml


echo "#--------------/////Certification Authority Setup/////----------------#"

cd ./certificates

# 0. Se generan la CA utilizando Dilithium3
openssl req -new -nodes \
-x509 \
-days 365 \
-newkey Dilithium3 \
-keyout ca/ca.key \
-out ca/ca.crt \
-config ca/ca.cnf 

# 1. Convertir el ca.key a ca.pem:	
cat ca/ca.crt ca/ca.key > ca/ca.pem

echo "#-----------------------------------------------------------#"


echo "#--------------/////Broker Setup/////----------------#"

# 2. Crear el certificado y la key del broker:
openssl req -new \
-newkey Dilithium3 \
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
-srcstorepass 123456 \
-provider org.bouncycastle.pqc.jcajce.provider.BouncyCastlePQCProvider \
-providerpath /home/ithaqua/Downloads/bcprov-jdk18on-1.78.1.jar 

# org.bouncycastle.pqc.jcajce.provider.BouncyCastlePQCProvider
# org.bouncycastle.jce.provider.BouncyCastleProvider

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

#---------- Dilithium Generator keytool ---------#

# keytool -genkeypair \
# -alias broker \
# -storetype pkcs12 \
# -keyalg DILITHIUM3 \
# -sigalg DILITHIUM3 \
# -keystore broker/broker.keystore.pkcs12 \
# -validity 365 \
# -storepass 123456 \
# -keypass 123456 \
# -dname "CN=Common Name, OU=Organizational Unit, O=Organization, L=Location, ST=State, C=Country" \
# -provider org.bouncycastle.pqc.jcajce.provider.BouncyCastlePQCProvider \
# -providerpath /home/ithaqua/Documents/Kafka/SandBox_Kafka/post-quantum-support-kafka/docker/libs/BouncyCustomProvider.jar 