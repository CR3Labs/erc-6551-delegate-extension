// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "openzeppelin-contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/proxy/Clones.sol";

import "account-abstraction/core/EntryPoint.sol";

import "erc6551/ERC6551Registry.sol";
import "erc6551/interfaces/IERC6551Account.sol";

import "tokenbound/AccountGuardian.sol";
import "tokenbound/AccountProxy.sol";

import "./mocks/MockERC721.sol";

import "../src/AccountDelegateExtension.sol";

contract AccountTest is Test {
    AccountDelegateExtension implementation;
    ERC6551Registry public registry;
    AccountGuardian public guardian;
    AccountProxy public proxy;
    IEntryPoint public entryPoint;

    MockERC721 public tokenCollection;

    function setUp() public {
        entryPoint = new EntryPoint();
        guardian = new AccountGuardian();
        implementation = new AccountDelegateExtension(address(guardian), address(entryPoint));
        proxy = new AccountProxy(address(implementation));

        registry = new ERC6551Registry();

        tokenCollection = new MockERC721();
    }

    function testDelegateFails(uint256 tokenId) public {
        address user1 = vm.addr(1);
        address user2 = vm.addr(2);

        tokenCollection.mint(user1, tokenId);
        assertEq(tokenCollection.ownerOf(tokenId), user1);

        address accountAddress = registry.createAccount(
            address(proxy), block.chainid, address(tokenCollection), tokenId, 0, abi.encodeWithSignature("initialize()")
        );

        vm.deal(accountAddress, 1 ether);

        AccountDelegateExtension account = AccountDelegateExtension(payable(accountAddress));

        // should fail if user2 tries to use account
        vm.prank(user2);
        vm.expectRevert(NotAuthorized.selector);
        account.executeCall(payable(user2), 0.1 ether, "");
    }

    function testDelegateSuceeds(uint256 tokenId) public {
        address user1 = vm.addr(1);
        address user2 = vm.addr(2);

        tokenCollection.mint(user1, tokenId);
        assertEq(tokenCollection.ownerOf(tokenId), user1);

        address accountAddress = registry.createAccount(
            address(proxy), block.chainid, address(tokenCollection), tokenId, 0, abi.encodeWithSignature("initialize()")
        );

        vm.deal(accountAddress, 1 ether);

        AccountDelegateExtension account = AccountDelegateExtension(payable(accountAddress));

        // should fail if user2 tries to use account
        vm.prank(user2);
        vm.expectRevert(NotAuthorized.selector);
        account.executeCall(payable(user2), 0.1 ether, "");

        // delegate user2 permissions to use account
        // TODO need a local version of Delegate.Cash

        // should succeed after user1 delegates user2 as owner
        // TODO
        vm.prank(user2);
        account.executeCall(payable(user2), 0.1 ether, "");
        assertEq(user2.balance, 0.1 ether);
    }
}
