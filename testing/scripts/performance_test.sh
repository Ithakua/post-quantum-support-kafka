#!/usr/bin/bash
# Test PQ KEM algorithms
# Pending run hybrid KEMs like p384_kyber768 (see https://github.com/open-quantum-safe/openssl#supported-algorithms)

## Uncomment if you are unsure if you are running the OQS version of OpenSSL and the corresponding libraries are loaded
# export LD_LIBRARY_PATH=/usr/local/lib
# export PATH=/usr/local/bin:$PATH

declare -a kems=(
    # [0]="P-256"
    # [1]="P-384"
    # [2]="P-521"
    # [3]="X448"
    # [4]="X25519"
)

declare -a pqkems=(
    [0]="kyber512"
    [1]="kyber768"
    [2]="kyber1024"
)

######### Begin modification zone ###############
#repetir="n"
repetir="y"
num_reps=20
# cafile="~/Documents/Kafka/SandBox_Kafka/post-quantum-support-kafka/certificates/ca/ca.pem"
# clientKey="~/Documents/Kafka/SandBox_Kafka/post-quantum-support-kafka/certificates/test/test-key.pem"
# clientCert="~/Documents/Kafka/SandBox_Kafka/post-quantum-support-kafka/certificates/test/test-signed.pem"
cafile="../certificates/ca/ca.pem"
clientKey="../certificates/test/test-key.pem"
clientCert="../certificates/test/test-signed.pem"
serverport="9093"  # Port of the already running server
######### End modification zone ###############

groups=$(echo "${kems[@]} ${pqkems[@]}" | sed -e 's/ /:/g')
#groups=$(echo "${pqkems[@]}" | sed -e 's/ /:/g')
rm -f zerofile && touch zerofile

# Printing message to inform user about the actions
echo "Ensure you have a server running on port $serverport. If not, start it before continuing."
echo "We will connect to the server on port $serverport."
echo "Proceed? (Type 'y' to continue)"
read -r answ

if [[ $answ == "y" ]]; then
    echo "Continuing..."
else
    echo "Exiting as per user request."
    exit 0
fi

results="results$(date +%d%m.%s).csv"
touch "$results"
echo "Results will be written to file $results"
declare -a line_results

if [[ $repetir == "n" ]]; then
    for i in "${kems[@]}" "${pqkems[@]}"; do
        echo "$i"
        START=$(date +%s.%N)
        # openssl s_client -CAfile "$cafile" -tls1_3 -groups "$i" -connect "localhost:$serverport" < zerofile 2>&1 | grep -i "Server Temp"
        openssl s_client \
            -cert "$clientCert" \
            -key "$clientKey" \
            -CAfile "$cafile" \
            -tls1_3 \
            -groups x448 \
            -connect "localhost:9093" \
            2>&1 | grep -i "Server Temp"
        END=$(date +%s.%N)
        DELTA=$(bc <<< "$END - $START")
        echo "${DELTA}"
    done
else
    j=0
    echo "$j ${kems[@]} ${pqkems[@]}" | sed -e 's/ /,/g' >> "$results"
    while (( j < num_reps )); do
        j=$((++j))
        line_results=("$j")
        for i in "${kems[@]}" "${pqkems[@]}"; do
            START=$(date +%s.%N)
            openssl s_client -CAfile "$cafile" -tls1_3 -groups "$i" -connect "localhost:$serverport" < zerofile 2>&1 >/dev/null
            END=$(date +%s.%N)
            DELTA=$(bc <<< "$END - $START")
            line_results+=("$DELTA")
        done
        echo "${line_results[*]}" | sed -e 's/ /,/g' >> "$results"
    done
fi
