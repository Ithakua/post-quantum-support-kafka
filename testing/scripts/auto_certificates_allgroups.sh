#!/bin/bash


# Seleccion del docker compose con autenticacion de cliente

cd ../

cp ./docker/docker-compose_allgroups.yaml ./testing/docker-compose.yaml


echo "#--------------Certification Authority Setup----------------#"

cd ./certificates

# 1. Generar la Certification Authority basada en un .cnf:
openssl req -new -nodes \
   -x509 \
   -days 365 \
   -newkey rsa:2048 \
   -keyout ca/ca.key \
   -out ca/ca.crt \
   -config ca/ca.cnf

echo "#-----------------------------------------------------------#"


echo "#--------------Broker Setup----------------#"

# 1. Crear el certificado y la key del broker:
openssl req -new \
-newkey rsa:2048 \
-keyout broker/broker.key \
-out broker/broker.csr \
-config broker/broker.cnf \
-nodes


# 2. Firmar los certificados con la CA:
openssl x509 -req \
-days 3650 \
-in broker/broker.csr \
-CA ca/ca.crt \
-CAkey ca/ca.key \
-CAcreateserial \
-out broker/broker.crt \
-extfile broker/broker.cnf \
-extensions req_v3

# 3. Convertir el certificado del servidor a formato pkcs12:
openssl pkcs12 -export \
-in broker/broker.crt \
-inkey broker/broker.key \
-chain \
-CAfile ca/ca.crt \
-name broker \
-out broker/broker.p12 \
-password pass:123456

# 4. Crear la broker keystore:
keytool -importkeystore \
-deststorepass 123456 \
-destkeystore broker/broker.keystore.pkcs12 \
-srckeystore broker/broker.p12 \
-deststoretype PKCS12  \
-srcstoretype PKCS12 \
-noprompt \
-srcstorepass 123456

# 5. Crear la client truststore y guardar la CA:
keytool -import \
    -alias KafkaTFG-ca \
    -keystore broker/broker.truststore.pkcs12 \
    -file ca/ca.crt \
    -storepass 123456  \
    -noprompt \
    -storetype PKCS12


# 6. Guardar las credenciales de la keystore, de la trustore y de la conexión ssl:
echo "123456" > broker/broker_sslkey_creds
echo "123456" > broker/broker_keystore_creds
echo "123456" > broker/broker_truststore_creds

echo "#-----------------------------------------------------------#"


echo "#--------------Client Setup----------------#"

# # SOLO SI SE NECESITA AUTENTICARSE POR PARTE DEL CLIENTE # #

# # 1. Crear el certificado y la key del cliente:
openssl req -new \
    -newkey rsa:2048 \
    -keyout clients/client-key.pem \
    -out clients/client-cert.csr \
    -config clients/client.cnf \
    -nodes

# # 2. Firma el certificado del cliente con la clave privada de la CA
openssl x509 -req \
    -days 3650 \
    -in clients/client-cert.csr \
    -CA ca/ca.crt \
    -CAkey ca/ca.key \
    -CAcreateserial \
    -out clients/client-signed.pem \
    -extfile clients/client.cnf \
    -extensions req_v3

# 3. Convertir el certificado del cliente a formato pkcs12:
openssl pkcs12 -export \
    -in clients/client-signed.pem \
    -inkey clients/client-key.pem \
    -chain \
    -CAfile ca/ca.crt \
    -name client_kafka \
    -out clients/client.p12 \
    -password pass:123456

# 4. Crear la client keystore:
keytool -importkeystore \
    -deststorepass 123456 \
    -destkeystore clients/client.keystore.pkcs12 \
    -srckeystore clients/client.p12 \
    -deststoretype PKCS12  \
    -srcstoretype PKCS12 \
    -noprompt \
    -srcstorepass 123456

#5. Crear la client truststore y guardar la CA:
keytool -import \
    -alias KafkaTFG-ca \
    -keystore clients/client.truststore.pkcs12 \
    -file ca/ca.crt \
    -storepass 123456  \
    -noprompt \
    -storetype PKCS12

# 6. Guardar las credenciales de la keystore, de la trustore y de la conexión:
echo "123456" > clients/client_sslkey_creds
echo "123456" > clients/client_keystore_creds
echo "123456" > clients/client_truststore_creds

echo "#-----------------------------------------------------------#"

# echo "#--------------TEST Client Setup----------------#"

# # # SOLO SI SE NECESITA AUTENTICARSE POR PARTE DEL CLIENTE # #
# # # 1. Crear el certificado y la key del cliente:
# openssl req -new \
#     -newkey rsa:2048 \
#     -keyout test/test-key.pem \
#     -out test/test-cert.csr \
#     -config test/test.cnf \
#     -nodes

# # # 2. Firma el certificado del cliente con la clave privada de la CA
# openssl x509 -req \
#     -days 3650 \
#     -in test/test-cert.csr \
#     -CA ca/ca.crt \
#     -CAkey ca/ca.key \
#     -CAcreateserial \
#     -out test/test-signed.pem \
#     -extfile test/test.cnf \
#     -extensions req_v3

# # 3. Convertir el certificado del cliente a formato pkcs12:
# openssl pkcs12 -export \
#     -in test/test-signed.pem \
#     -inkey test/test-key.pem \
#     -chain \
#     -CAfile ca/ca.pem \
#     -name client_kafka_test \
#     -out test/test.p12 \
#     -password pass:123456

# # 4. Crear la client keystore:
# keytool -importkeystore \
#     -deststorepass 123456 \
#     -destkeystore test/test.keystore.pkcs12 \
#     -srckeystore test/test.p12 \
#     -deststoretype PKCS12  \
#     -srcstoretype PKCS12 \
#     -noprompt \
#     -srcstorepass 123456

# #5. Crear la client truststore y guardar la CA:
# keytool -import \
#     -alias KafkaTFG-ca \
#     -keystore test/test.truststore.pkcs12 \
#     -file ca/ca.crt \
#     -storepass 123456  \
#     -noprompt \
#     -storetype PKCS12

# # 6. Guardar las credenciales de la keystore, de la trustore y de la conexión:
# echo "123456" > test/test_sslkey_creds
# echo "123456" > test/test_keystore_creds
# echo "123456" > test/test_truststore_creds

# echo "#-----------------------------------------------------------#"