// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test,console} from "forge-std/Test.sol";
import {Registry} from "../src/Registry.sol";
import {Nft} from "../src/Nft.sol";
import {MyAccount  as TBA} from "../src/MyAccount.sol";

contract RegistryTest is Test {
    Registry registry;
    Nft nft;
    TBA tba;
    bytes32 salt = bytes32(0);
    address owner = makeAddr("owner");
    address alice = makeAddr("alice");
    string tokenUri = "https://ipfs.io/ipfs/QmbNzRa3WkeazbQnGgi4AVxaDpM22DZfDrvrnXPy8yLD5k";

    function setUp() public {
        registry = new Registry();
        nft = new Nft(owner);
        tba = new TBA();
    }

    function testCreateAccount() public {
        vm.prank(owner);
        nft.mint(alice , 1, tokenUri);

        address account = registry.createAccount(
            address(tba),
            salt,
            block.chainid,
            address(nft),
            1
        );

        address checkAccount = registry.account(
            address(tba),
            salt,
            block.chainid,
            address(nft),
            1
        );
        assertEq(account.code.length , 173);
        assertEq(account , checkAccount);
    }
}