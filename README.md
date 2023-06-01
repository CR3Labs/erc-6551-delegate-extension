# EIP-6551 Delegate Extension

This code provides an extension to EIP-6551 `Account.sol` to override the `isAuthorized` method adding support for delegate.cash and warm.xyz.

## Deployed Implementations

* SEPOLIA: `0x41063579Ee0ed03d4D638DB8909f8b7244a2B9E3`
* GOERLI: `0x0`
* MAINNET: `0x0`

## Development

**Setup**

1. $ `git submodule --init --recursive`
2. $ `forge install`

**Running Tests**

1. $ `forge test`

**Deploying**

1. Copy `.env.example` to `.env`
2. Update env vars in `.env`
3. $ `forge build`
4. $ `forge script DeployAccount --rpc-url sepolia --private-key $TESTNET_ACCOUNT_DEPLOYER --verify --broadcast`
 