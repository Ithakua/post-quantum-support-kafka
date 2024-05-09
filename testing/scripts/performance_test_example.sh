#!/usr/bin/bash
# test PQ KEM algorithms
# pending run hybrid KEMs like p384_kyber768 (see https://github.com/open-quantum-safe/openssl#supported-algorithms)

## Uncomment if you are unsure if you are running the oqs version of openssl and the corresponding libraries are loaded
# export LD_LIBRARY_PATH=/usr/local/lib
# export PATH=/usr/local/bin:$PATH

declare -a kems=(
    [0]="P-256"
    [1]="P-384"
    [2]="P-521"
#    [3]="X448"
#    [4]="X25519"
)

declare -a pqkems=(
    [0]="bikel1"
    [1]="bikel3"
    [2]="kyber512"
    [3]="kyber768"
    [4]="kyber1024"
#    [8]="frodo640aes"
#    [9]="frodo640shake"
#    [10]="frodo976aes"
#    [11]="frodo976shake"
#    [12]="frodo1344aes"
#    [13]="frodo1344shake"
    [14]="hqc128"
    [15]="hqc192"
#    [16]="ntrulpr653"
#    [17]="ntrulpr761"
#    [18]="ntrulpr857"
#    [19]="ntrulpr1277"
#    [20]="sntrup653"
#    [21]="sntrup761"
#    [22]="sntrup857"
#    [23]="sntrup1277"
#    [24]="lightsaber"
#    [25]="saber"
#    [26]="firesaber"
)

declare -a hybrid_kems=(
    [0]="p256_bikel1"
    [1]="p384_bikel3"
    [2]="p256_kyber512"
    [3]="p384_kyber768"
    [4]="p521_kyber1024"
#    [8]="p256_frodo640aes"
#    [9]="p256_frodo640shake"
#    [10]="p384_frodo976aes"
#    [11]="p384_frodo976shake"
#    [12]="p521_frodo1344aes"
#    [13]="p521_frodo1344shake"
    [14]="p256_hqc128"
    [15]="p384_hqc192"
#    [16]="p256_ntrulpr653"
#    [17]="p256_ntrulpr761"
#    [18]="p384_ntrulpr857"
#    [19]="p521_ntrulpr1277"  
#    [20]="p256_sntrup653"
#    [21]="p256_sntrup761"
#    [22]="p384_sntrup857"
#    [23]="p521_sntrup1277"  
#    [24]="p256_lightsaber"
#    [25]="p384_saber"
#    [26]="p521_firesaber"
)

######### begin modification zone ###############
#repetir="n"
repetir="y"
num_reps=100
cafile="demoCA/cacert.pem"
servercert="server.pem"
serverkey="server.key"
######### end modification zone ###############

groups=`echo ${kems[@]} ${pqkems[@]} ${hybrid_kems[@]} |sed -e 's/ /:/g'`
#groups=`echo ${pqkems[@]} |sed -e 's/ /:/g'`
rm -f zerofile; touch zerofile

echo "Ensure you are executing openssl server in a different tab (CTRL-SHIFT-TAB) and answer 'y': "
echo "openssl s_server -CAfile $cafile -cert $servercert  -key $serverkey -tls1_3 -groups $groups -port 4445"
answ="n"; while [[ $answ == "n" ]] ; do echo -n "continue [y/n]"; read answ; done

results="results$(date +%d%m.%s).csv"
touch $results
echo "results will be written to file $results"
declare -a line_results[20]

if [ $repetir == "n" ]
then
    for i in ${kems[@]} ${pqkems[@]} ${hybrid_kems[@]}
#    for i in ${pqkems[@]}
    do 
	echo $i
	START=$(date +%s.%N)
	openssl s_client -CAfile $cafile -tls1_3 -groups $i -port 4445 < zerofile 2>&1 | grep -i "Server Temp"
	END=$(date +%s.%N)
	printf -v DELTA "%g" $(bc <<<"$END - $START")
	echo "${DELTA}"
    done
else
    j=0;
    echo $j ${kems[@]} ${pqkems[@]} ${hybrid_kems[@]}|sed -e 's/ /,/g' >> ${results}
    while (( j < num_reps )); do
	j=$((++j))
	line_results[0]=${j}
	for i in ${kems[@]} ${pqkems[@]} ${hybrid_kems[@]}
	do
	    START=$(date +%s.%N)
	    openssl s_client -CAfile $cafile -tls1_3 -groups $i -port 4445 < zerofile 2>&1 >/dev/null
	    END=$(date +%s.%N)
	    printf -v DELTA "%g" $(bc <<<"$END - $START")	    
	    line_results+=(${DELTA})
	    #TIMEFORMAT="%3R,%3U,%3S" a="`time openssl s_client -CAfile $cafile -tls1_3 -groups $i -port 4445 < zerofile 2>&1| grep -i \"Server Temp\"`"
	done
	echo "${line_results[@]}"|sed -e 's/ /,/g' >> $results
	unset line_results[@] # remove array elements
    done
fi