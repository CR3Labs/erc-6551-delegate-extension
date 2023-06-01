// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "tokenbound/Account.sol";

// @dev Warm.xyz does not appear to have
// a testnet version of their wallet proxy

// interface WarmInterface {
//     function ownerOf(address contractAddress, uint256 tokenId) external view returns (address);
// }

interface DelegateCashInterface {
    function checkDelegateForToken(address delegate, address vault, address contract_, uint256 tokenId)
        external
        view
        returns (bool);
}

contract AccountDelegateExtension is Account {
    /// @dev Mainet Address of the Warm registry Contract
    // address public constant WARM_ADDRESS = 0xC3AA9bc72Bd623168860a1e5c6a4530d3D80456c;

    /// @dev Goerli Address of the DelegateCash registry Contract
    address public constant DELEGATE_CASH_ADDRESS = 0x00000000000076A84feF008CDAbe6409d2FE638B;

    constructor(address _guardian, address entryPoint_) Account(_guardian, entryPoint_) {}

    /// @dev Returns the authorization status for a given caller
    /// implements warm.xyz to check if caller is authorized to execute on
    /// behalf of
    function isAuthorized(address caller) public view virtual override returns (bool) {
        // authorize entrypoint for 4337 transactions
        if (caller == _entryPoint) return true;

        (uint256 chainId, address tokenContract, uint256 tokenId) = ERC6551AccountLib.token();
        address _owner = IERC721(tokenContract).ownerOf(tokenId);

        // authorize token owner
        if (caller == _owner) return true;

        // authorize caller if owner has granted permissions
        if (permissions[_owner][caller]) return true;

        // authorize if _owner has delegated caller as an operator via warm registry
        // WarmInterface warm = WarmInterface(WARM_ADDRESS);
        // if (warm.ownerOf(tokenContract, tokenId) == _owner) return true;

        // authorize if _owner has delegated caller as an operator via delegate registry
        DelegateCashInterface delegate = DelegateCashInterface(DELEGATE_CASH_ADDRESS);
        if (delegate.checkDelegateForToken(caller, _owner, tokenContract, tokenId)) return true;

        // authorize trusted cross-chain executors if not on native chain
        if (chainId != block.chainid && IAccountGuardian(guardian).isTrustedExecutor(caller)) return true;

        return false;
    }
}
