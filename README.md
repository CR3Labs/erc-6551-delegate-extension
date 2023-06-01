# EIP-6551 Delegate Extension

This code provides an extension to EIP-6551 `Account.sol` to override the `isAuthorized` method adding support for delegate.cash and warm.xyz.

## Deployed Implementations

* SEPOLIA: `0xe747f4014a68897c50048f0603276c8a6294dd1a`
* MAINNET: `0x0`

## Development

**Setup**

1. $ `git submodule --init --recursive`
2. $ `forge install`

**Running Tests**

1. `forge test`


**Deploying**

1. Copy `.env.example` to `.env`
2. Update env vars in `.env`
3. $ `forge build`
4. $ `forge create DeployAccount --rpc-url sepolia|goerli --private-key <PRIVATE_KEY>`
