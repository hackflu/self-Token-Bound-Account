// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {Nft} from "../../src/Nft.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NftTest is Test {
    Nft public nft;
    address owner = makeAddr("owner");
    address alice = makeAddr("alice");
    address randomUser = makeAddr("randomUser");
    string tokenUri =
        "https://ipfs.io/ipfs/QmbNzRa3WkeazbQnGgi4AVxaDpM22DZfDrvrnXPy8yLD5k";

    function setUp() public {
        nft = new Nft(owner);
    }

    /*//////////////////////////////////////////////////////////////
                              MINT FUNCTION
    //////////////////////////////////////////////////////////////*/
    function testMint() public {
        vm.prank(owner);
        nft.mint(alice, 1, tokenUri);
        assertEq(nft.ownerOf(1), alice);
        assertEq(nft.tokenURI(1), tokenUri);
    }

    function testMintWithALreadyUser() public {
        vm.prank(owner);
        nft.mint(alice , 1 , tokenUri);

        vm.prank(owner);
        vm.expectRevert(abi.encodeWithSelector(Nft.nft_UserAlreadyExist.selector, 1));
        nft.mint(randomUser , 1 , tokenUri);
    } 

    /*//////////////////////////////////////////////////////////////
                            SUPPORTSINTERFACE
    //////////////////////////////////////////////////////////////*/

    function testSupportInterface() public view {
        assertEq(nft.supportsInterface(type(IERC721).interfaceId) ,true);
    }

}
