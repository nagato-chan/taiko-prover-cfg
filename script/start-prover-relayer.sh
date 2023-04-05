#!/bin/sh

set -eou pipefail


if [ "$ENABLE_PROVER" == "true" ]; then
    if [ ! -f "./wait" ];then
        wget https://github.com/ufoscout/docker-compose-wait/releases/download/2.9.0/wait
        chmod +x ./wait
    fi

    WAIT_HOSTS=zkevm-chain-prover-rpcd:${PORT_ZKEVM_CHAIN_PROVER_RPCD} WAIT_TIMEOUT=180 ./wait
	
    taiko-client prover \
        --l1.ws ${PROVER_L1_ENDPOINT_WS} \
        --l2.ws ws://l2_execution_engine:${PORT_L2_EXECTION_ENGINE_WS} \
        --l1.http ${PROVER_L1_ENDPOINT_HTTP} \
        --l2.http http://l2_execution_engine:${PORT_L2_EXECTION_ENGINE_HTTP} \
        --taikoL1 ${TAIKO_L1_ADDRESS} \
        --taikoL2 ${TAIKO_L2_ADDRESS} \
        --zkevmRpcdEndpoint http://zkevm-chain-prover-rpcd:${PORT_ZKEVM_CHAIN_PROVER_RPCD} \
        --zkevmRpcdParamsPath /data \
        --l1.proverPrivKey ${L1_PROVER_PRIVATE_KEY} \
		--proofNumberRate ${PROVER_PROOF_NUMBER_RATE} \
        --maxConcurrentProvingJobs ${PROVER_MAX_CONCURRENT_PROVING_JOBS} \
else
    sleep infinity
fi
