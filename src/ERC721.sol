// contracts/AchievemintNFT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "openzeppelin-contracts/access/Ownable.sol";

contract TBADelegateExtension721 is ERC721URIStorage, Ownable {
    constructor() ERC721("TBADelegateExtension721", "TBAD") {}

    function mint(address to, string memory tokenURI, uint256 tokenId) public virtual onlyOwner {
        _mint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);
    }
}
