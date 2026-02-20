// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {MyAccount as TBA} from "../../src/MyAccount.sol";
import {Nft} from "../../src/Nft.sol";
import {Registry} from "../../src/Registry.sol";
import {
    MessageHashUtils
} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import {IERC165} from "@openzeppelin/contracts/interfaces/IERC165.sol";
import {Mock} from "../Mock/mock.sol";

contract AccountTest is Test {
    TBA tba;
    Nft nft;
    Registry registry;
    address owner = makeAddr("owner");
    string tokenUri =
        "https://ipfs.io/ipfs/QmbNzRa3WkeazbQnGgi4AVxaDpM22DZfDrvrnXPy8yLD5k";
    bytes32 salt = bytes32(0);
    Mock target; // Declare target as a state variable
    uint256 privateKey =
        0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    function setUp() public {
        tba = new TBA();
        nft = new Nft(owner);
        registry = new Registry();
        target = new Mock(); // Initialize target in setUp
    }

    function testToken() public {
        // 1. deploy nft
        vm.prank(owner);
        nft.mint(owner, 1, tokenUri);

        // 2. proxy Tba addess
        address proxyAddress = registry.createAccount(
            address(tba),
            salt,
            block.chainid,
            address(nft),
            1
        );
        address tbaAddr = 0xaa0e36cF7eaC70b492Bc4F619D38C2bFc8e00769;
        console.logBytes(tbaAddr.code);
        // 3. call Account function with TBA
        (uint256 chainId, address nftAddr, uint256 tokenId) = TBA(
            payable(proxyAddress)
        ).token();
        console.log(chainId);
        console.log(nftAddr);
        console.log(tokenId);

        // assertEq(chainId , block.chainid);
        assertEq(nftAddr, address(nft));
        assertEq(tokenId, 1);
    }

    function testOwner() public {
        // 1. deploy nft
        vm.prank(owner);
        nft.mint(owner, 1, tokenUri);

        // 2. proxy Tba addess
        address proxyAddress = registry.createAccount(
            address(tba),
            salt,
            block.chainid,
            address(nft),
            1
        );
        // 3. call Account function with TBA
        address owner_generated = TBA(payable(proxyAddress)).owner();
        console.log(owner);
        assertEq(owner, owner_generated);
    }

    modifier requireToCreateTBA() {
        // 1. deploy nft
        vm.prank(owner);
        nft.mint(owner, 1, tokenUri);
        _;
    }
    function testInValidSigner() public requireToCreateTBA {
        // 2. proxy Tba addess
        address proxyAddress = registry.createAccount(
            address(tba),
            salt,
            block.chainid,
            address(nft),
            1
        );
        bytes4 selector = TBA(payable(proxyAddress)).isValidSigner(
            owner,
            abi.encodePacked(
                bytes32(
                    0x8da5cb5b00000000000000000000000000000000000000000000000000000000
                )
            )
        );
        console.logBytes4(selector);
        assertEq(selector, bytes4(0x523e3260));
    }

    function testisValidSignature() public requireToCreateTBA {
        // 2. proxy Tba addess
        address proxyAddress = registry.createAccount(
            address(tba),
            salt,
            block.chainid,
            address(nft),
            1
        );
        // 3. create ECDSA signature
        bytes32 messageHash = keccak256(abi.encodePacked("Hello"));
        bytes32 ethSignedMessageHash = MessageHashUtils.toEthSignedMessageHash(
            messageHash
        );
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(
            privateKey,
            ethSignedMessageHash
        );
        bytes memory signature = abi.encodePacked(r, s, v);

        bytes4 selector = TBA(payable(proxyAddress)).isValidSignature(
            messageHash,
            signature
        );
        assertEq(selector, bytes4(0));
    }

    function testSupportsInterface() public requireToCreateTBA {
        // 2. proxy Tba addess
        address proxyAddress = registry.createAccount(
            address(tba),
            salt,
            block.chainid,
            address(nft),
            1
        );
        assertEq(
            TBA(payable(proxyAddress)).supportsInterface(
                type(IERC165).interfaceId
            ),
            true
        );
    }

    function testExecute() public requireToCreateTBA {
        address proxyAddress = registry.createAccount(
            address(tba),
            salt,
            block.chainid,
            address(nft),
            1
        );

        bytes memory data = abi.encodeWithSignature("setValue(uint256)", 42);

        // 2. Perform the execution as the owner
        vm.prank(owner);
        bytes memory result = TBA(payable(proxyAddress)).execute(
            address(target), // to
            0, // value (no ETH sent)
            data, // data (the encoded function call)
            0 // operation (call)
        );

        // 3. Assertions
        assertEq(target.value(), 42); // Verify target state changed
    }

    
}
