## Elimina todos los archivos relacionados con certificados, credenciales y ficheros de prueba:

# Test files
find . \( -type f -name "*.csv" \)  -delete 
find . \( -type f -name "*.pcap" \)  -delete 

# Broker
cd ../certificates/broker
find . \( -type f -name "*.key" -o -name "*.crt" -o -name "*.csr" -o -name "*.pem" -o -name "*.p12" -o -name "*.pkcs12" -o -name "*_creds" -o -name "*.jks" -o -name "*.old"  \)  -delete

# Clients
cd ../clients
find . \( -type f -name "*.key" -o -name "*.crt" -o -name "*.csr" -o -name "*.pem" -o -name "*.p12" -o -name "*.pkcs12" -o -name "*_creds" -o -name "*.jks"  \)  -delete

# CA
cd ../ca
find . \( -type f -name "*.crt" -o -name "*.key" -o -name "*.pem" \)  -delete