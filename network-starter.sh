function _exit(){
    printf "Exiting:%s\n" "$1"
    exit -1
}

# Exit on first error, print all commands.
set -ev
set -o pipefail

# Where am I?
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export FABRIC_CFG_PATH="${DIR}/../config"

cd "../test-network/"

./network.sh down
./network.sh up createChannel -c test -s couchdb -ca

./network.sh deployCC -c test -ccn cert -ccp ../fyp-chaincode/chaincode -ccl go -ccep "OR('Org1MSP.peer','Org2MSP.peer')"

# Copy the connection profiles so they are in the correct organizations.
cp "organizations/peerOrganizations/org1.example.com/connection-org1.yaml" "${DIR}gateway/"
cp "organizations/peerOrganizations/org2.example.com/connection-org2.yaml" "${DIR}gateway/"

cp "organizations/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp/signcerts/"* "organizations/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp/signcerts/User1@org1.example.com-cert.pem"
cp "organizations/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp/keystore/"* "organizations/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp/keystore/priv_sk"

cp "organizations/peerOrganizations/org2.example.com/users/User1@org2.example.com/msp/signcerts/"* "organizations/peerOrganizations/org2.example.com/users/User1@org2.example.com/msp/signcerts/User1@org2.example.com-cert.pem"
cp "organizations/peerOrganizations/org2.example.com/users/User1@org2.example.com/msp/keystore/"* "organizations/peerOrganizations/org2.example.com/users/User1@org2.example.com/msp/keystore/priv_sk"