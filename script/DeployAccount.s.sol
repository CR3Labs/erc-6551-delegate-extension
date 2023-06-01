// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "tokenbound/AccountProxy.sol";
import "../src/AccountDelegateExtension.sol";

contract DeployAccount is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("TESTNET_ACCOUNT_DEPLOYER");
        vm.startBroadcast(deployerPrivateKey);

        AccountDelegateExtension implementation = new AccountDelegateExtension{
            salt: 0x6551D6551D6551D6551D6551D6551D6551D6551D6551D6551D6551D6551D6551
        }(
            0xB0219b60f0535FB3B62eeEC51EC4C765d138Ac0A, // guardian
            0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789 // entry point
        );

        new AccountProxy{
            salt: 0x6551D6551D6551D6551D6551D6551D6551D6551D6551D6551D6551D6551D6551
        }(address(implementation));

        vm.stopBroadcast();
    }
}
