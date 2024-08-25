=> Create new Foundry Project 

### forge init 

=> To import aggregator from chainlink github
   https://github.com/smartcontractkit/chainlink-brownie-contracts
 ###  forge install  smartcontractkit/chainlink-brownie-contracts@0.6.1 --no-commit   
 You can also use version  1.1.1

## connect chainlink contract to brownie contract
=> check foundry.toml

remappings = ["@chainlink/contracts/=lib/chainlink-brownie-contracts/contracts/"]
=>  forge remappings 
=> forge build 
=>  forge test -vv

### Deploying 
forge script script/DeployFundMe.s.sol 
 


=> forge coverage --fork-url $SEPOLIA_RPC_URL
 =>forge test --fork-url $MAINNET_RPC_URL 


 ### How to test specific files
 test a specific function forge test -m testAddsFunderToArrayOfFunders
 ### second methods
 forge test --match-test testPriceFeedVersionIsAccurate -vvv --rpc-url $SEPOLIA_RPC_URL
 forge test --match-test testUserCanFundInteractions -vvv 
 forge test --match-test  testAddsFunderToArrayOfFunders
 

### Load env file 
source .env




=> forge inspect FundMe storageLayout 
=> cast storage address number, anvil must be runing



### Style Guild 

immutable variables = immutable (small i) i_owner
constant var  = constants (Capital letter) eg MINIMUM_USD
storage variable = s_priceFeed


### Integration Test 
### Use Foundry DevOps

=> A repo to get the most recent deployment from a given environment in foundry. This way, you can do scripting off previous deployments in solidity.

It will look through your broadcast folder at your most recent deployment.

### forge install ChainAccelOrg/foundry-devops --no-commit

foundry.toml file
ffi = true   ## foundry will run directly on my machine


### In case you run into issues 
curl -L https://foundry.paradigm.xyz | bash
foundryup


## Make files 

## AUTOMATE   sudo apt install make 
## To deploy on sepolia make deploy-sepolia

example 

-include .env

build:; forge build

make build 

deploy-sepolia:
      forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(SEPOLIA_RPC_URL)
	  --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY)
	  -vvv

    => make deploy-sepolia 





### ZKSYNC TEST 

switch from vanila foundry to zksync 
foundryup-zksync 

=> Back to vanila foundry
foundryup


### Github

initialize git init -b main
=> some times foundry initializes it just do git status 


